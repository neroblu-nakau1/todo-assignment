<?php

$params = require(__DIR__ . '/params.php');

$config = [
    'id' => 'basic',
    'basePath' => dirname(__DIR__),
    'bootstrap' => ['log'],
    'components' => [
        'request' => [
            // !!! insert a secret key in the following (if it is empty) - this is required by cookie validation
            'cookieValidationKey' => 'lAsaK7DFMIk9dDVpISnEKlETx0mpCPlo',
        ],
        'cache' => [
            'class' => 'yii\caching\FileCache',
        ],
        'user' => [
            'identityClass' => 'app\models\User',
            'enableAutoLogin' => true,
        ],
        'mailer' => [
            'class' => 'yii\swiftmailer\Mailer',
            // send all mails to a file by default. You have to set
            // 'useFileTransport' to false and configure a transport
            // for the mailer to send real emails.
            'useFileTransport' => true,
        ],
        'log' => [
            'traceLevel' => YII_DEBUG ? 3 : 0,
            'targets' => [
                [
                    'class' => 'yii\log\FileTarget',
                    'levels' => ['error', 'warning'],
                ],
            ],
        ],
        'db' => require(__DIR__ . '/db.php'),
        'urlManager' => [
            'enablePrettyUrl' => true,
            'showScriptName' => false,
            'rules' => [
                '/' => 'browse/index',
                'POST api/tasks/'                 => 'tasks/create',
                'GET api/tasks/'                  => 'tasks/read',
                'PUT api/tasks/<identifier>'     => 'tasks/update',
                'DELETE api/tasks/<identifiers>' => 'tasks/delete',
            ],
        ],
        'errorHandler' => [
            'class' => 'yii\web\ErrorHandler',
            'errorAction' => 'api/error',
        ],
        'response' => [
            'class' => 'yii\web\Response',
//            'on beforeSend' => function (\yii\base\Event $event) {
//                /** @var \yii\web\Response $response */
//                $response = $event->sender;
//                var_dump($response->format);exit;
//
//
//                if (is_null($response->data['data']) && $response->statusCode == 404) {
//                    $token = $response->data['token'] ?? "";
//                    $response->data = ['message' => 'APIが見つかりません', 'token' => $token, 'data' => []];
//                } else if ($response->statusCode >= 500) {
//                    $response->setStatusCode(500);
//                    $response->data = ['message' => 'サーバー側でエラーが発生しました', 'token' => '', 'data' => []];
//                }
//            }
        ],
    ],
    'params' => $params,
];

if (YII_ENV_DEV) {
    // configuration adjustments for 'dev' environment
    $config['bootstrap'][] = 'debug';
    $config['modules']['debug'] = [
        'class' => 'yii\debug\Module',
        // uncomment the following to add your IP if you are not connecting from localhost.
        //'allowedIPs' => ['127.0.0.1', '::1'],
    ];

    $config['bootstrap'][] = 'gii';
    $config['modules']['gii'] = [
        'class' => 'yii\gii\Module',
        // uncomment the following to add your IP if you are not connecting from localhost.
        //'allowedIPs' => ['127.0.0.1', '::1'],
    ];
}

return $config;
