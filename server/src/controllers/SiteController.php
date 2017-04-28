<?php
namespace app\controllers;

use app\models\Task;
use app\models\User;
use Yii;
use yii\web\Controller;
use yii\web\Response;

class SiteController extends Controller
{
    public $enableCsrfValidation = false;

    /**
     * ステータスコード
     * @var integer
     */
    protected $code = 200;

    /**
     * レスポンスメッセージ
     * @var string
     */
    protected $message = 'OK';

    public function init()
    {
        parent::init();
        Yii::$app->response->format = Response::FORMAT_JSON;
    }

    public function afterAction($action, $result)
    {
        Yii::$app->response->setStatusCode($this->code);
        return [
            'message' => $this->message,
            'data' => $result,
        ];
    }



    public function actionIndex()
    {
//        $model = new User();
//        $model->token = 'sample';
//        $model->save();

        $model = new Task();
        $model->title = "あああ";
        $model->user_id = 1;
        $model->date = '2017-03-23';
        $model->priority = 2;

        $model->save();

        return [

        ];
    }
}