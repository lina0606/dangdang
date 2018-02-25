<?php
header('Content-Type:application/json');

@$phone = $_REQUEST['phone'];

if(empty($phone))
{
    echo '[]';
    return;
}

require('init.php');

$sql = "SELECT rb_order.oid,rb_order.addr,rb_order.order_time,rb_order.user_name,rb_dish.img_sm,rb_dish.did FROM rb_dish,rb_order WHERE rb_order.phone=$phone AND rb_order.did=rb_dish.did";
$result = mysqli_query($conn,$sql);

$output = [];
while(true){
    $row = mysqli_fetch_assoc($result);
    if(!$row)
    {
        break;
    }
    $output[] = $row;
}

echo json_encode($output);

?>




