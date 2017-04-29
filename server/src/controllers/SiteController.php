<?php
namespace app\controllers;

use app\models\TaskAPI;
use Yii;

class SiteController extends APIBaseController
{
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
        return ['identifier' => $identifier];
    }

    private function deleteTask()
    {
        return ['method' => 'delete'];
    }
}