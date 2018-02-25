<?php
/**根据用户id查询订单数据**/
header('Content-Type:application/json');

$output = [];

@$userid = $_REQUEST['userid'];

if(empty($userid)){
    echo "[]"; //若客户端未提交用户id，则返回一个空数组，
    return;    //并退出当前页面的执行
}

//访问数据库
require('init.php');

$sql = "SELECT rb_order.oid,rb_order.userid,rb_order.phone,rb_order.addr,
rb_order.totalprice,rb_order.user_name,rb_order.order_time,
rb_orderdetails.did,rb_orderdetails.dishcount,rb_orderdetails.price,
rb_dish.name,rb_dish.img_sm

 from rb_order,rb_orderdetails,rb_dish
WHERE rb_order.oid = rb_orderdetails.oid and rb_orderdetails.did = rb_dish.did and rb_order.userid='$userid'";
$result = mysqli_query($conn, $sql);

$output['data'] = mysqli_fetch_all($result, MYSQLI_ASSOC);

echo json_encode($output);
?>
