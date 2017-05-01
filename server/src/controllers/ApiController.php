<?php
namespace app\controllers;

use Yii;
use app\models\User;
use yii\web\Controller;
use yii\web\Response;

class ApiController extends Controller
{
    public $enableCsrfValidation = false;

    /* @var User $user ユーザ */
    protected $user;

    /* @var integer $code ステータスコード */
    protected $code = 200;

     /* @var string $message レスポンスメッセージ */
    protected $message = 'OK';

    /**
     * @inheritdoc
     */
    public function init()
    {
        parent::init();
        Yii::$app->response->format = Response::FORMAT_JSON;
    }

    /**
     * @inheritdoc
     */
    public function beforeAction($action)
    {
        $this->user = (new User())->authorize();
        return parent::beforeAction($action);
    }

    /**
     * @inheritdoc
     */
    public function afterAction($action, $result)
    {
        Yii::$app->response->setStatusCode($this->code);
        return [
            'message' => $this->message,
            'token'   => $this->user->token,
            'data'    => $result,
        ];
    }

    public function actionError() {}
}