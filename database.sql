SET NAMES 'utf8';
DROP DATABASE IF EXISTS rb_new;
CREATE DATABASE rb_new CHARSET=UTF8;
USE rb_new;
CREATE TABLE rb_dish(
    did INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(64),
    price FLOAT(6,2),
    img_sm VARCHAR(64),
    img_lg VARCHAR(64),
    detail VARCHAR(2048),
    material VARCHAR(2048)
);
INSERT INTO rb_dish(did,img_sm,img_lg,name,price,material,detail) VALUES
(   null,
    '1.jpg',
    '1-1.jpg',
    '人民的名义',
    35,
    '作者:周梅森',
    '根据本书改编而成的同名电视剧正在热播，由陆毅、张丰毅等40余名实力戏骨联袂出演！著名作家周梅森潜心八年、六易其稿，一部反腐高压下中国政治和官场生态的长幅画卷。'),
(   null,
    '32.jpg',
    '3-3.jpg',
    '人间失格',
    19,
    '作者:（日）太宰治',
    '此版本当当网销量遥遥领先！(公版书)“尽管人是这么的让人失望，但人还是这么的需要人“太宰治对这世界深情的告白。?'
),
(   null,
    '2.jpg',
    '2-2.jpg',
    '我的第一本地理启蒙书',
    35,
    '作者:郑利强',
    '给孩子妙趣横生的地理启蒙：从身边的东西南北，到脚下这片土地，再到我们圆滚滚的地球。好玩、实用的地理常识，由近及远的探索，让孩子从小会认路、懂旅行，打开眼界，看得更高、更远！（步印童书馆原创）'
),
(   null,
    '4.jpg',
    '4-4.jpg',
    '岛上书店',
    11,
    '作者:（美）加·泽文 著 Gabrielle Zevin',
    ' （每个人的生命中，都有无比艰难的那一年，将人生变得美好而辽阔）现象级全球畅销书！一年内畅销全球30国！ 每个人的生命中，都有无比艰难的那一年，将人生变得美好而辽阔！
     ️'
),
(   null,
    '6.jpg',
    '6-6.jpg',
    '解忧杂货店',
    34,
    '作者:(日)东野圭吾',
    '《白夜行》后东野圭吾备受欢迎作品：不是推理小说，却更扣人心弦'
),
(   null,
    '7.jpg',
    '7-7.jpg',
    '写给儿童的中国历史（全14册）',
    263,
     '作者:陈卫平',
    '第十届文津奖获奖图书，畅销台湾三十载，贯通上下五千年。鲜活、系统、客观，帮助孩子别嫌疑、明是非、定犹豫。学会了解自己，评价世界。台湾小鲁镇社之宝、儿童文学 少年读史记
  '
),
(   null,
    '8.jpg',
    '8-8.jpg',
     '白夜行',
    34,
    '作者:(日)东野圭吾',
    '东野圭吾推理小说无冕之王。全新精装典藏版。'
    )
    ,
(   null,
    '9.jpg',
    '9-9.jpg',
    '资治通鉴',
    25,
    '作者:（宋)司马光',
    '礼品装家庭必读书，金牌畅销系列，原著基础上精心编译，直译为主，逐字逐句一一对应，文字流畅，文笔优美。以期读者能更好的了解当时的历史。'
);
/*用户表*/
CREATE TABLE rb_users(
    userid INT PRIMARY KEY AUTO_INCREMENT, /*购物车编号*/
    uname VARCHAR(20),                     /*用户名*/
    pwd VARCHAR(20),                       /*密码*/
    phone VARCHAR(20)                      /*电话*/
);
INSERT INTO rb_users VALUES
(NULL,'mary','11111','13111112345'),
(NULL,'jerry','22222','13819196547'),
(NULL,'john','33333','13819196547');
/*订单表*/
CREATE TABLE rb_order(
    oid INT PRIMARY KEY AUTO_INCREMENT,     /*订单ID*/
    userid INT,                             /*用户*/
    phone VARCHAR(16),                      /*联系电话*/
    user_name VARCHAR(16),                  /*收货方用户名*/
    order_time LONG,                        /*下单时间*/
    addr VARCHAR(256),                      /*订单地址*/
    totalprice FLOAT(6,2)                   /*订单总价*/
);
INSERT INTO rb_order VALUES
(NULL,1,'13501234567','淘淘',1445154859209,'大钟寺中鼎B座',20.5),
(NULL,1,'13501257543','琳琳',1445154997543,'大钟寺中鼎A座',12.5),
(NULL,2,'13207654321','小明',1445254997612,'大钟寺中鼎C座',55),
(NULL,2,'13899999999','笑笑',1445354959209,'大钟寺中鼎E座',35),
(NULL,3,'13683675299','梅梅',1445355889209,'大钟寺中鼎F座',45);
/**购物车表**/
CREATE TABLE rb_cart(
    ctid INT PRIMARY KEY AUTO_INCREMENT, /*购物车编号*/
    userid INT,                          /*用户编号：假定有用户id为 1 和 3 的两个用户有数据*/
    did INT,                             /*产品编号*/
    dishCount INT                      /*数量*/
);
INSERT INTO rb_cart VALUES (1,1,1,1),
(2,1,2,4),
(3,1,5,2),
(4,3,2,10),
(5,3,6,1);
/**订单详情表**/
CREATE TABLE rb_orderdetails(
    oid INT ,                            /*订单编号*/
    did INT,                             /*产品id*/
    dishCount INT,                     /*购买数量*/
    price FLOAT(8,2)                     /*产品单价：需要记载，因为产品价格可能波动*/
);
INSERT INTO rb_orderdetails VALUES (1,1,2,5),
(1,2,1,10.5),
(2,3,1,12.5),
(3,1,3,5),
(3,2,4,10),
(4,4,7,5),
(5,5,5,4),
(5,6,2,12.5);
