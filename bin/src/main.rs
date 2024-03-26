use config::{CERT_KEY, CFG};
use salvo::{
    catcher::Catcher,
    conn::{
        rustls::{Keycert, RustlsConfig},
        TcpListener,
    },
    server::ServerHandle,
    Listener, Router, Server, Service,
};
use tokio::signal;

#[tokio::main]
async fn main() {
    let _guard = clia_tracing_config::build()
        .filter_level(&CFG.log.filter_level)
        .with_ansi(CFG.log.with_ansi)
        .to_stdout(CFG.log.to_stdout)
        .directory(&CFG.log.directory)
        .file_name(&CFG.log.file_name)
        .rolling(&CFG.log.rolling)
        .init();
    tracing::info!("log level: {}", &CFG.log.filter_level);
    println!("{:?}", &CFG.server.name);
    let router = Router::new();
    let service: Service = router.into();
    println!("🌪️ {} 正在启动 ", &CFG.server.name);
    println!("🔄 在以下位置监听 {}", &CFG.server.address);
    match CFG.server.ssl {
        true => {
            println!(
                "📖 Open API页面: https://{}/swagger-ui",
                &CFG.server.address.replace("0.0.0.0", "127.0.0.1")
            );
            println!(
                "🔑 登录页面: https://{}/login",
                &CFG.server.address.replace("0.0.0.0", "127.0.0.1")
            );
            let config = RustlsConfig::new(
                Keycert::new()
                    .cert(CERT_KEY.cert.clone())
                    .key(CERT_KEY.key.clone()),
            );
            let acceptor = TcpListener::new(&CFG.server.address)
                .rustls(config)
                .bind()
                .await;
            let server = Server::new(acceptor);
            let handle = server.handle();
            tokio::spawn(shutdown_signal(handle));
            server.serve(service).await;
        }
        false => {
            println!(
                "📖 Open API页面: http://{}/swagger-ui",
                &CFG.server.address.replace("0.0.0.0", "127.0.0.1")
            );
            println!(
                "🔑 登录页面: http://{}/login",
                &CFG.server.address.replace("0.0.0.0", "127.0.0.1")
            );
            let acceptor = TcpListener::new(&CFG.server.address).bind().await;
            let server = Server::new(acceptor);
            let handle = server.handle();
            tokio::spawn(shutdown_signal(handle));
            server.serve(service).await;
        }
    }
}
async fn shutdown_signal(handle: ServerHandle) {
    let ctrl_c = async {
        signal::ctrl_c()
            .await
            .expect("failed to install Ctrl+C handler");
    };

    #[cfg(unix)]
    let terminate = async {
        signal::unix::signal(signal::unix::SignalKind::terminate())
            .expect("failed to install signal handler")
            .recv()
            .await;
    };

    #[cfg(not(unix))]
    let terminate = std::future::pending::<()>();

    tokio::select! {
        _ = ctrl_c => tracing::info!("ctrl_c signal received"),
        _ = terminate => tracing::info!("terminate signal received"),
    }
    handle.stop_graceful(std::time::Duration::from_secs(60));
}
