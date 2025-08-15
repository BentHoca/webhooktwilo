<?php
// Recebe os dados enviados pela Twilio
$status = $_POST['MessageStatus'] ?? '';
$sid = $_POST['MessageSid'] ?? '';
$errorCode = $_POST['ErrorCode'] ?? '';

// Salva no banco, loga ou toma alguma ação
file_put_contents('status_log.txt', date('Y-m-d H:i:s') . " | $sid | $status | $errorCode\n", FILE_APPEND);

// Sempre responda com status 200
http_response_code(200);
?>
