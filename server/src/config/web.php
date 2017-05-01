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
            'rules' => require(__DIR__ . '/routes.php'),
        ],
        'errorHandler' => [
            'class' => 'yii\web\ErrorHandler',
            'errorAction' => 'site/error',
        ],
        'response' => [
            'class'       => 'yii\web\Response',
            'on beforeSend' => function (\yii\base\Event $event) {
                /** @var \yii\web\Response $response */
                $response = $event->sender;
                if ($response->data !== null && !$response->isSuccessful) {
                    if (isset($response->data['type'])) {
                        if ($response->statusCode == 404) {
                            $response->data = ['message' => 'APIが見つかりません'];
                        } else {
                            $response->setStatusCode(500);
                            $response->data['message'] = 'サーバー側でエラーが発生しました';
                            var_dump($response);exit;
                        }
                    }
                }
            }
        ],
    ],
    'params' => $params,
];





//<?php
//use app\modules\exchange\helpers\Messages;
//
//return [
//    'id'                  => 'pollet-exchange',
//    'controllerNamespace' => 'app\modules\exchange\controllers',
//    'components'          => [
//        'errorHandler' => [
//            'class'       => 'yii\web\ErrorHandler',
//            'errorAction' => 'api/default/error',
//        ],
//        'response'     => [
//            'class'       => 'yii\web\Response',
//            'on beforeSend' => function (\yii\base\Event $event) {
//                /** @var \yii\web\Response $response */
//                $response = $event->sender;
//
//                if ($response->statusCode === Messages::HTTP_MAINTENANCE) {
//                    $response->data = ['message' => Messages::ERR_MAINTENANCE];
//                } else if ($response->data !== null && !$response->isSuccessful) {
//                    if (isset($response->data['type'])) {
//                        if ($response->statusCode == Messages::HTTP_NOT_FOUND) {
//                            $response->data = ['message' => Messages::ERR_NOT_FOUND];
//                        } else {
//                            $response->setStatusCode(Messages::HTTP_SERVER_ERROR);
//                            $response->data = ['message' => Messages::ERR_SERVER_ERROR];
//                        }
//                    }
//                }
//            },
//        ],
//    ],
//];





























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
