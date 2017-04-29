<?php
namespace app\controllers;

use app\models\Task;
use app\models\TaskAPI;
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
            'message' => $this->message,
            'token'   => $this->user->token,
            'data'    => $result,
        ];
    }

    public function actionIndex()
    {
        $request = Yii::$app->request;
        if ($request->isDelete) {
            return $this->deleteTask();
        } else if ($request->isPut) {
            return $this->putTask($request->get('identifier'), $request->post());
        } else if ($request->isPost) {
            return $this->postTask($request->post());
        } else if ($request->isGet) {
            return $this->getTask();
        } else {
            return $this->deleteTask();
        }
    }

    private function getTask()
    {
        return ['method' => 'get'];
    }

    private function postTask($params)
    {
        $taskApi = new TaskAPI();
        $taskApi->setScenario(TaskAPI::SCENARIO_INSERT);
        $params['user_id'] = $this->user->id;

        if (!$taskApi->insert($params)) {
            return $this->makeErrorResponse($taskApi->errorMessage());
        }
        $this->code = 201;
        return ['identifier' => $taskApi->task->identifier];
    }

    private function putTask($identifier, $params)
    {
        $taskApi = new TaskAPI();
        $taskApi->setScenario(TaskAPI::SCENARIO_UPDATE);
        $params['user_id']    = $this->user->id;
        $params['identifier'] = $identifier;

        if (!$taskApi->update($params)) {
            return $this->makeErrorResponse($taskApi->errorMessage());
        }
        $this->code = 200;
        return ['identifier' => $identifier, 'params' => $params];
    }

    private function deleteTask()
    {
        return ['method' => 'delete'];
    }

    private function makeErrorResponse($message, $data = [], $code = 400)
    {
        $this->code    = $code;
        $this->message = $message;
        return $data;
    }
}