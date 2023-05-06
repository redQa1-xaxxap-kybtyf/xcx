

*产品主表(product) 

CREATE TABLE product (
   id INT NOT NULL AUTO_INCREMENT,                     
   merchant_id INT NOT NULL,                              
   category_id INT NOT NULL,                            
   sku VARCHAR(50) NOT NULL,                            
   name_en VARCHAR(255) NOT NULL,                       
   name_zh VARCHAR(255) NOT NULL,                       
   is_shelf BOOLEAN NOT NULL DEFAULT TRUE,              
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,  
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (id),
   UNIQUE (sku),
   INDEX (name_en),
   INDEX (name_zh),
   INDEX (merchant_id),
   CONSTRAINT fk_product_merchant  
     FOREIGN KEY (merchant_id) REFERENCES merchant(id)  
       ON DELETE CASCADE,
   CONSTRAINT fk_product_category  
     FOREIGN KEY (category_id) REFERENCES product_category(id)  
       ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




*产品分类表(product_category) 

CREATE TABLE product_category (
   id INT NOT NULL AUTO_INCREMENT,                     -- 分类ID(主键)
   merchant_id INT NOT NULL,                            -- 商户ID(外键) 
   parent_id INT NULL,                                 -- 上级分类ID(外键)
   name VARCHAR(255) NOT NULL,                            -- 分类名称
   sort_order INT NULL DEFAULT 0,                      -- 排序权重
   icon_url VARCHAR(255) NULL,                        -- 分类图标
   description VARCHAR(255) NULL,                     -- 分类描述
   created_at TIMESTAMP NULL,                         -- 创建时间
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
                                                       -- 更新时间
   , PRIMARY KEY (id)
   , CONSTRAINT fk_product_category_parent  
     FOREIGN KEY (parent_id) REFERENCES product_category(id)
   , CONSTRAINT fk_product_category_merchant
     FOREIGN KEY (merchant_id) REFERENCES merchant(id)  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


*产品列表表(product_list) 

CREATE TABLE product_list (
   id INT NOT NULL AUTO_INCREMENT,                       -- 列表ID(主键)  
   merchant_id INT NOT NULL,                                -- 商户ID(外键)
   name VARCHAR(255) NOT NULL,                            -- 列表名称  
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,   -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 更新时间
   , PRIMARY KEY (id)
   , CONSTRAINT fk_product_list_merchant  
     FOREIGN KEY (merchant_id) REFERENCES merchant(id)  
     ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



产品列表明细表(product_list_detail)

CREATE TABLE product_list_detail (
   product_list_id INT NOT NULL,                          -- 列表ID(外键)  
   product_id INT NOT NULL,                                 -- 产品ID(外键)
   sort_order INT UNSIGNED NOT NULL DEFAULT 0,            -- 排序权重
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,   -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
                                                         -- 更新时间
   PRIMARY KEY (product_list_id, product_id),
   CONSTRAINT fk_product_list_detail_list  
     FOREIGN KEY (product_list_id) REFERENCES product_list(id),
   CONSTRAINT fk_product_list_detail_product
     FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


*产品属性名表(product_attribute_name) 

CREATE TABLE product_attribute_name (
   id INT NOT NULL AUTO_INCREMENT,                     -- 属性名ID(主键)  
   merchant_id INT NOT NULL,                              -- 商户ID(外键)
   name VARCHAR(255) NOT NULL,                           -- 属性名称
   PRIMARY KEY (id),
   CONSTRAINT fk_product_attribute_name_merchant  
     FOREIGN KEY (merchant_id) REFERENCES merchant(id) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

*产品属性值表(product_attribute_value)

CREATE TABLE product_attribute_value (
   id INT NOT NULL AUTO_INCREMENT,                      -- 属性值ID(主键)  
   merchant_id INT NOT NULL,                               -- 商户ID(外键) 
   attribute_name_id INT NOT NULL,                       -- 属性名ID(外键)  
   product_id INT NOT NULL,                               -- 产品ID(外键)
   value VARCHAR(255) NOT NULL,                          -- 属性值
   PRIMARY KEY (id),
   CONSTRAINT fk_product_attribute_value_merchant  
     FOREIGN KEY (merchant_id) REFERENCES merchant(id),
   CONSTRAINT fk_product_attribute_value_name  
     FOREIGN KEY (attribute_name_id) REFERENCES product_attribute_name(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;




产品图片表(product_image)

CREATE TABLE product_image (
   id INT NOT NULL AUTO_INCREMENT,                    -- 图片ID(主键)  
   merchant_id INT NOT NULL,                           -- 商户ID(外键)
   product_id INT NOT NULL,                            -- 产品ID(外键)
   image_url VARCHAR(255) NOT NULL,                   -- 图片URL
   is_main BOOLEAN NOT NULL DEFAULT FALSE,            -- 是否主图
   width INT UNSIGNED NULL,                            -- 图片宽度  
   height INT UNSIGNED NULL,                           -- 图片高度
   size INT UNSIGNED NULL,                             -- 图片大小
   format VARCHAR(10) NULL,                           -- 图片格式
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,-- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 更新时间
   PRIMARY KEY (id),
   CONSTRAINT fk_product_image_merchant  
     FOREIGN KEY (merchant_id) REFERENCES merchant(id),
   CONSTRAINT fk_product_image_product
     FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



*图片哈希表(image_hash)

CREATE TABLE image_hash (
   id INT NOT NULL AUTO_INCREMENT,                      -- 哈希ID(主键)  
   hash_val CHAR(64) NOT NULL,                           -- 图片哈希值
   image_url VARCHAR(255) NOT NULL,                      -- 图片URL
   file_name VARCHAR(150) NOT NULL,                      -- 图片文件名
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,  -- 添加时间      
   PRIMARY KEY (id),
   UNIQUE (hash_val)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


*用户图片关联表(user_image)

CREATE TABLE user_image (
   id INT NOT NULL AUTO_INCREMENT,               -- 关联ID(主键)  
   user_id INT NOT NULL,                            -- 用户ID(外键)
   hash_id INT NOT NULL,                            -- 哈希ID(外键)
   created_at DATETIME NOT NULL,                   -- 图片上传时间
   PRIMARY KEY (id),
   CONSTRAINT fk_user_image_user  
     FOREIGN KEY (user_id) REFERENCES user(id),
   CONSTRAINT fk_user_image_hash
     FOREIGN KEY (hash_id) REFERENCES image_hash(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



公告表(announcement)

CREATE TABLE announcement (
   id INT NOT NULL AUTO_INCREMENT,                    -- 公告ID(主键)  
   type ENUM('merchant', 'admin') NOT NULL,           -- 公告类型  
   publisher_id INT,                                 -- 发布者ID  
   title VARCHAR(255) NOT NULL,                        -- 公告标题  
   content TEXT NOT NULL,                             -- 公告内容
   release_time DATETIME NOT NULL,                    -- 发布时间
   revoke_time DATETIME NULL,                          -- 撤回时间
   scope JSON NOT NULL,                               -- 发布范围
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,-- 创建时间  
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,   
                                                      -- 更新时间
   PRIMARY KEY (id),
   CONSTRAINT fk_announcement_publisher  
    FOREIGN KEY (publisher_id) REFERENCES merchant(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
 


2.用户表(user)

CREATE TABLE user (
   id INT NOT NULL AUTO_INCREMENT,             -- 用户ID(主键)  
   openid VARCHAR(50) NOT NULL,                  -- 微信OpenID
   unionid VARCHAR(50),                         -- 微信UnionID
   nickname VARCHAR(50),                        -- 微信昵称
   avatar VARCHAR(255),                         -- 头像
   mobile VARCHAR(20),                          -- 手机号
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 更新时间  
   PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



3.用户详细信息表(user_detail) 

CREATE TABLE user_detail (
   id INT NOT NULL AUTO_INCREMENT,             -- 详细信息ID(主键)  
   user_id INT NOT NULL,                          -- 用户ID(外键)  
   first_merchant_id INT,                        -- 首次登录商户ID
   region VARCHAR(50),                           -- 区域
   register_source VARCHAR(20),                  -- 注册来源
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间  
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
   PRIMARY KEY (id),
   CONSTRAINT fk_user_detail_user 
     FOREIGN KEY (user_id) REFERENCES user(id)  
     ON DELETE CASCADE
     ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


4.用户行为表(user_action)
CREATE TABLE user_action (
   id BIGINT NOT NULL AUTO_INCREMENT,        -- 用户行为ID(主键)  
   user_id INT NOT NULL,                        -- 用户ID
   merchant_id INT NOT NULL,                    -- 商户ID
   product_id INT NOT NULL,                     -- 产品ID
   page VARCHAR(50) NOT NULL,                   -- 页面
   duration INT NOT NULL,                       -- 浏览时长
   stay_duration INT NOT NULL,                  -- 停留时长
   clicks INT NOT NULL,                         -- 点击量
   session_id VARCHAR(50) NOT NULL,             -- SessionID
   ip VARCHAR(15) NOT NULL,                     -- 用户IP
   type ENUM('click', 'browse') NOT NULL,       -- 行为类型 
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 更新时间  
   PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



5.设备信息表(device_info)

CREATE TABLE device_info (  
   id BIGINT NOT NULL AUTO_INCREMENT,     -- 设备ID(主键)
   user_id INT NOT NULL,                     -- 用户ID(外键)
   brand VARCHAR(50) NOT NULL,               -- 设备品牌
   model VARCHAR(50) NOT NULL,               -- 设备型号
   os VARCHAR(50) NOT NULL,                  -- 操作系统
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
   PRIMARY KEY (id),  
   CONSTRAINT fk_device_info_user  
     FOREIGN KEY (user_id) REFERENCES user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



6.推荐设置表(recommend_set)

CREATE TABLE recommend_set (
   id INT NOT NULL AUTO_INCREMENT,         -- 推荐ID(主键)
   merchant_id INT NOT NULL,               -- 商户ID(外键) 
   recommend_type ENUM('item', 'category') NOT NULL, -- 推荐方式
   algorithm_param TEXT NULL,              -- 推荐算法参数  
   weight_coef DOUBLE NOT NULL DEFAULT 0,  -- 权重系数  
   recommend_weight INT NOT NULL,          -- 推荐权重  
   effective_time DATETIME NOT NULL,       -- 生效时间
   invalid_time DATETIME,                  -- 失效时间 
   is_enabled TINYINT(1) NOT NULL DEFAULT 1, -- 是否启用
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
                                            -- 更新时间
   UNIQUE KEY uniq_recommend_set_01 (merchant_id, recommend_type),  
   CONSTRAINT fk_recommend_set_merchant 
     FOREIGN KEY (merchant_id) REFERENCES merchant(id),
   PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


7. 商户模板表(merchant_template) 

CREATE TABLE merchant_template (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,       -- 模板ID(主键)  
   merchant_id INT NOT NULL,             -- 商户ID(外键)
   name VARCHAR(50) NOT NULL,            -- 模板名称  
   content TEXT NOT NULL,                -- 模板内容 
   version_major INT NOT NULL,           -- 主版本号
   version_minor INT NOT NULL,           -- 次版本号  
   category ENUM('home', 'list', 'detail') NOT NULL, -- 模板分类  
   is_enabled TINYINT(1) NOT NULL DEFAULT 1,  -- 是否启用         
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
   UNIQUE KEY uniq_merchant_template_01 (merchant_id, name, version_major),
   CONSTRAINT fk_merchant_template_merchant  
     FOREIGN KEY (merchant_id) REFERENCES merchant(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


8.管理员表(admin)

CREATE TABLE admin (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,         -- 管理员ID(主键)
   name VARCHAR(50) NOT NULL,              -- 管理员姓名
   account VARCHAR(50) NOT NULL UNIQUE,   -- 管理员账号(唯一)
   password VARCHAR(64) NOT NULL,         -- 管理员密码(哈希加密)
   salt VARCHAR(64) NOT NULL,             -- 管理员Salt(哈希加密) 
   email VARCHAR(50) NULL,                    -- 邮箱
   role INT NOT NULL,                            -- 角色
   permission JSON NOT NULL,                 -- 权限(RBAC)
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
                                               -- 更新时间
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;








1.商户表(merchant)

CREATE TABLE merchant (
   id INT NOT NULL,                      -- 商户ID(主键)  
   uuid CHAR(32) NOT NULL UNIQUE,        -- 商户UUID(唯一)
   appid CHAR(32) NULL UNIQUE,           -- 平台端商户ID
   mobile VARCHAR(11) NOT NULL UNIQUE,   -- 手机号 
   password VARCHAR(32) NOT NULL,        -- 密码(MD5加密)
   type ENUM('platform', 'thirdparty') NOT NULL,  -- 商户类型
   expired_at DATETIME NOT NULL,         -- 到期时间
   status ENUM('normal', 'disabled') NOT NULL DEFAULT 'normal',  -- 商户状态
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,  -- 创建时间  
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
   PRIMARY KEY (id),
   UNIQUE KEY uniq_merchant_01 (uuid),
   UNIQUE KEY (appid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;












10.用户反馈联系表(user_feedback_contact)

CREATE TABLE user_feedback_contact (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  -- 联系ID(主键)  
   feedback_id INT NOT NULL,                -- 反馈ID(外键)
   contact TEXT NOT NULL,                    -- 联系方式
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
                                                 -- 更新时间  
   CONSTRAINT fk_user_feedback_contact_feedback  
     FOREIGN KEY (feedback_id) REFERENCES user_feedback(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


9.用户反馈表(user_feedback)

CREATE TABLE user_feedback (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,   -- 反馈ID(主键)  
   user_id INT NOT NULL,                         -- 用户ID 
   merchant_id INT NULL,                         -- 商户ID(外键)
   type ENUM('complain', 'suggestion') NOT NULL, -- 反馈类型  
   content TEXT NOT NULL,                        -- 反馈内容
   status ENUM('unread', 'read', 'replied') NOT NULL DEFAULT 'unread', -- 处理状态
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
                                              -- 更新时间  
   CONSTRAINT fk_user_feedback_merchant  
     FOREIGN KEY (merchant_id) REFERENCES merchant(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


10反馈处理表(feedback_processing) 

CREATE TABLE feedback_processing(
   id INT NOT NULL AUTO_INCREMENT,      -- 处理ID(主键)     
   feedback_id INT NOT NULL,            -- 反馈ID(外键)  
   status ENUM('unread', 'processing', 'processed') NOT  NULL DEFAULT 'unread',  
                                       -- 处理状态
   processed_at DATETIME NULL,          -- 处理时间
   result TEXT NULL,                    -- 处理结果
   operator VARCHAR(50) NULL,           -- 处理人员
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 更新时间
   PRIMARY KEY (id),
   CONSTRAINT fk_feedback_processing_feedback  
     FOREIGN KEY (feedback_id) REFERENCES user_feedback(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


11.短信记录表(sms_record) 

CREATE TABLE sms_record (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,        -- 记录ID(主键)  
   merchant_id INT NOT NULL,                 -- 商户ID(外键)  
   mobile VARCHAR(11) NOT NULL,             -- 手机号码
   code CHAR(6) NOT NULL,                    -- 验证码(MD5加密)
   sent_at DATETIME NOT NULL,               -- 发送时间
   status ENUM('valid', 'invalid', 'expired') NOT NULL DEFAULT 'valid',  
                                           -- 验证状态
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间  
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,   
                                                -- 更新时间 
   CONSTRAINT fk_sms_record_merchant FOREIGN KEY (merchant_id) REFERENCES merchant(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


*套餐表(package)

CREATE TABLE package(
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 套餐ID(主键)
   name VARCHAR(50) NOT NULL,             -- 套餐名称
   price DOUBLE NOT NULL,                 -- 套餐价格
   duration INT NOT NULL,                 -- 套餐时长
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
                                             -- 更新时间  
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



*商户类型表(merchant_type)
CREATE TABLE merchant_type (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,   -- 类型ID(主键)  
   name VARCHAR(50) NOT NULL,              -- 商户类型名称
   attribute JSON NOT NULL,                 -- 商户类型特性
   permission JSON NOT NULL,               -- 商户类型权限
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
                                             -- 更新时间
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4



*用户收藏表(user_favorite)

CREATE TABLE user_favorite (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,     -- 收藏ID(主键)  
   user_id INT NOT NULL,                      -- 用户ID(外键)  
   merchant_id INT NOT NULL,                 -- 商户ID(外键)  
   product_id INT NOT NULL,                   -- 产品ID(外键)
   favorited_at DATETIME NOT NULL,          -- 收藏时间
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间  
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,   
                                               -- 更新时间
   CONSTRAINT fk_user_favorite_user FOREIGN KEY (user_id) REFERENCES user(id),  
   CONSTRAINT fk_user_favorite_merchant FOREIGN KEY (merchant_id) REFERENCES merchant(id), 
   CONSTRAINT fk_user_favorite_product FOREIGN KEY (product_id) REFERENCES product(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



*轮播图表(banner) 

CREATE TABLE banner (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,         
   merchant_id INT NOT NULL,                 
   image_url TEXT NOT NULL,                  
   product_id INT NULL,                   
   sort INT NOT NULL DEFAULT 0,            
   effective_at DATETIME NOT NULL,         
   invalid_at DATETIME NULL,                
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, 
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   CONSTRAINT fk_banner_merchant  
     FOREIGN KEY (merchant_id) REFERENCES merchant(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



页面表(page) 

CREATE TABLE page (
   id INT NOT NULL AUTO_INCREMENT,         -- 页面ID(主键)    
   merchant_id INT NOT NULL,                  -- 商户ID(外键)
   name VARCHAR(50) NOT NULL,                  -- 页面名称
   url VARCHAR(255) NOT NULL,                -- 页面URL            
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  
                                                -- 更新时间   
   CONSTRAINT fk_page_merchant FOREIGN KEY (merchant_id) REFERENCES merchant(id),
   INDEX uidx_page_url(url),                 -- URL唯一索引  
   PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



访问记录表(visit_record)

CREATE TABLE visit_record (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,      
   user_id INT NOT NULL,                   
   merchant_id INT NOT NULL,              
   page_id INT NOT NULL,                   
   total_duration INT NOT NULL,           
   visited_at DATETIME NOT NULL,         
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, 
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   CONSTRAINT fk_visit_record_user  
     FOREIGN KEY (user_id) REFERENCES user(id),
   CONSTRAINT fk_visit_record_merchant  
     FOREIGN KEY (merchant_id) REFERENCES merchant(id),
   CONSTRAINT fk_visit_record_page
     FOREIGN KEY (page_id) REFERENCES page(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


操作日志表(operation_log)

CREATE TABLE operation_log (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,        -- 日志ID(主键)  
   operator_id INT NOT NULL,                  -- 操作人ID    
   merchant_id INT NOT NULL,                -- 商户ID(外键)
   table_name VARCHAR(50) NOT NULL,         -- 数据库表名    
   type ENUM('add', 'update', 'delete') NOT NULL, -- 操作类型
   content TEXT NOT NULL,                     -- 操作内容
   result ENUM('success', 'fail') NOT NULL,    -- 操作结果
   ip VARCHAR(15) NOT NULL,                    -- 操作IP
   operated_at DATETIME NOT NULL,            -- 操作时间
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间  
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 更新时间
   CONSTRAINT fk_operation_log_merchant 
     FOREIGN KEY (merchant_id) REFERENCES merchant(id),
   INDEX idx_operation_log_table_name (table_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4


广告表(advertisement)

CREATE TABLE advertisement (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,         -- 广告ID(主键)  
   advertiser_id INT NOT NULL,               -- 广告商ID  
   name VARCHAR(50) NOT NULL,                -- 广告名称
   content TEXT NOT NULL,                    -- 广告内容 
   type ENUM('banner', 'native', 'popup') NOT NULL, -- 广告类型
   scope JSON NOT NULL,                       -- 投放范围
   delivery_time DATETIME NOT NULL,          -- 投放时段(开始时间)
   end_time DATETIME NOT NULL,                -- 投放时段(结束时间)
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间      
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
                                               -- 更新时间
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



商户联系表(merchant_contact)

CREATE TABLE merchant_contact (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,         
   merchant_id INT NOT NULL,                  
   contact TEXT NOT NULL,                     
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, 
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   CONSTRAINT fk_merchant_contact_merchant  
     FOREIGN KEY (merchant_id) REFERENCES merchant(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;







消息表

CREATE TABLE message (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 将id列指定为主键
   sender_id INT NOT NULL,
   receiver_id INT NOT NULL,
   merchant_id INT,
   type ENUM('text', 'image', 'video') NOT NULL,
   content TEXT NOT NULL,
   sent_at DATETIME NOT NULL,
   read_at DATETIME NULL,
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES user(id),
   CONSTRAINT fk_message_receiver FOREIGN KEY (receiver_id) REFERENCES user(id),
   CONSTRAINT fk_message_merchant FOREIGN KEY (merchant_id) REFERENCES merchant(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


 统计表

CREATE TABLE stat (
   id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,  -- 主键  
   category ENUM('view', 'sales', 'like') NOT NULL, -- 统计类别  
   type VARCHAR(50) NOT NULL,                    -- 统计类型
   count INT NOT NULL DEFAULT 0,                -- 统计数量 
   date DATE NOT NULL,                           -- 统计日期
   merchant_id INT,                              -- 商户ID(外键) 
   created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP, -- 创建时间  
   updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,   
                                                    -- 更新时间  
   UNIQUE KEY uniq_stat_01 (type, date),
   CONSTRAINT fk_stat_merchant FOREIGN KEY (merchant_id) REFERENCES merchant(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
