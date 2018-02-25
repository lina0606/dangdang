SET NAMES 'utf8';
DROP DATABASE IF EXISTS rb;
CREATE DATABASE rb CHARSET=UTF8;
USE rb;
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
    '5.jpg',
    '6-6.jpg',
    '解忧杂货店',
    34,
    '作者:(日)东野圭吾',
    '《白夜行》后东野圭吾备受欢迎作品：不是推理小说，却更扣人心弦'
),
(   null,
    '6.jpg',
    '6-6.jpg',
    '写给儿童的中国历史（全14册）',
    263,
     '作者:陈卫平 ',
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
CREATE TABLE rb_order(
    oid INT PRIMARY KEY AUTO_INCREMENT,
    phone VARCHAR(16),
    user_name VARCHAR(16),
    sex INT,    /*1:男  2:女*/
    order_time LONG,
    addr VARCHAR(256),
    did INT
);
INSERT INTO rb_order(oid, phone,user_name,sex,order_time,addr,did) VALUES
(NULL,'13501234567','婷婷',2,1445154859209,'大钟寺中鼎B座',3),
(NULL,'13501234567','婷婷',2,1445254959209,'大钟寺中鼎B座',2),
(NULL,'13501234567','婷婷',2,1445354959209,'大钟寺中鼎B座',5);

