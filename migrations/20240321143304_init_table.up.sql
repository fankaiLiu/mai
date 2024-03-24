-- Add up migration script here
-- ----------------------------
-- Table structure for system_users
-- ----------------------------
CREATE TABLE "system_users"
(
    "id"          int8                                        NOT NULL,
    "username"    varchar(30) COLLATE "pg_catalog"."default"  NOT NULL,
    "password"    varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
    "nickname"    varchar(30) COLLATE "pg_catalog"."default"  NOT NULL,
    "remark"      varchar(500) COLLATE "pg_catalog"."default",
    "dept_id"     int8,
    "post_ids"    varchar(255) COLLATE "pg_catalog"."default",
    "email"       varchar(50) COLLATE "pg_catalog"."default",
    "mobile"      varchar(11) COLLATE "pg_catalog"."default",
    "sex"         int2,
    "avatar"      varchar(100) COLLATE "pg_catalog"."default",
    "status"      int2                                        NOT NULL,
    "login_ip"    varchar(50) COLLATE "pg_catalog"."default",
    "login_date"  timestamp(6),
    "creator"     varchar(64) COLLATE "pg_catalog"."default",
    "create_time" timestamp(6)                                NOT NULL,
    "updater"     varchar(64) COLLATE "pg_catalog"."default",
    "update_time" timestamp(6)                                NOT NULL,
    "deleted"     int2                                        NOT NULL DEFAULT 0,
    "tenant_id"   int8                                        NOT NULL DEFAULT 0
)
;
COMMENT
ON COLUMN "system_users"."id" IS '用户ID';
COMMENT
ON COLUMN "system_users"."username" IS '用户账号';
COMMENT
ON COLUMN "system_users"."password" IS '密码';
COMMENT
ON COLUMN "system_users"."nickname" IS '用户昵称';
COMMENT
ON COLUMN "system_users"."remark" IS '备注';
COMMENT
ON COLUMN "system_users"."dept_id" IS '部门ID';
COMMENT
ON COLUMN "system_users"."post_ids" IS '岗位编号数组';
COMMENT
ON COLUMN "system_users"."email" IS '用户邮箱';
COMMENT
ON COLUMN "system_users"."mobile" IS '手机号码';
COMMENT
ON COLUMN "system_users"."sex" IS '用户性别';
COMMENT
ON COLUMN "system_users"."avatar" IS '头像地址';
COMMENT
ON COLUMN "system_users"."status" IS '帐号状态（0正常 1停用）';
COMMENT
ON COLUMN "system_users"."login_ip" IS '最后登录IP';
COMMENT
ON COLUMN "system_users"."login_date" IS '最后登录时间';
COMMENT
ON COLUMN "system_users"."creator" IS '创建者';
COMMENT
ON COLUMN "system_users"."create_time" IS '创建时间';
COMMENT
ON COLUMN "system_users"."updater" IS '更新者';
COMMENT
ON COLUMN "system_users"."update_time" IS '更新时间';
COMMENT
ON COLUMN "system_users"."deleted" IS '是否删除';
COMMENT
ON COLUMN "system_users"."tenant_id" IS '租户编号';
COMMENT
ON TABLE "system_users" IS '用户信息表';

ALTER TABLE "system_users"
    ADD CONSTRAINT "system_user_pkey" PRIMARY KEY ("id");

CREATE UNIQUE INDEX "idx_username" ON "system_users" USING btree (
    "username" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST,
    "update_time" "pg_catalog"."timestamp_ops" ASC NULLS LAST,
    "tenant_id" "pg_catalog"."int8_ops" ASC NULLS LAST
    );

