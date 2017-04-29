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

    /* @var User $user ユーザ */
    private $user;

    /* @var integer $code ステータスコード */
    private $code = 200;

     /* @var string $message レスポンスメッセージ */
    private $message = 'OK';

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
            'token' => $this->user->token,
            'message' => $this->message,
            'data' => $result,
        ];
    }

    public function actionIndex()
    {
        return [];



        /*


        $user = PolletUser::find()->active()->userCodeSecret($headerXPolletId)->one();
        if (!$user) {
            throw new NotAcceptableHttpException("エラー(406)が発生しました。こちらからお問い合わせください。");
        } else if (!Yii::$app->user->login($user, 60 * 60 * 24 * 30)) { // ログインの有効期間を30日に
            throw new UnauthorizedHttpException("エラー(401)が発生しました。アプリを再インストールするか、\nこちらからお問い合わせください。");
        }

        Yii::$app->session->set(self::SESSION_STORED_USER_CODE_KEY, $headerXPolletId);

        if (isset($app_operation)) {
            return $this->redirect($app_operation);
        } else {
            return $this->redirect(Dispatcher::forIndex($user));
        }*/
    }

    public function actionIndex2()
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