<?php
namespace app\controllers;

use app\models\Task;
use app\models\TaskAPI;
use Yii;

class TasksController extends ApiController
{
    /**
     * @return array
     */
    public function actionIndex()
    {
        $request = Yii::$app->request;
        $identifier = $request->get('identifier') ?? "";

        if ($request->isDelete) {
            return $this->deleteTask($identifier);
        } else if ($request->isPut) {
            return $this->putTask($identifier, $request->post());
        } else if ($request->isPost) {
            return $this->postTask($request->post());
        } else if ($request->isGet) {
            return $this->getTask();
        } else {
            $this->code    = TaskAPI::HTTP_NOTFOUND;
            $this->message = '';
            return [];
        }
    }

    /**
     * タスクの取得処理
     *
     * @return array
     */
    private function getTask()
    {
        $taskApi = new TaskAPI($this->user->id, TaskAPI::SCENARIO_SELECT);

        return $this->makeSucceedResponse($taskApi, array_map(function(Task $task) {
            return $task->toArray();
        }, $taskApi->fetchAll()));
    }

    /**
     * タスクの追加処理
     *
     * @param $params
     * @return array
     */
    private function postTask($params)
    {
        $taskApi = new TaskAPI($this->user->id, TaskAPI::SCENARIO_INSERT);

        if (!$taskApi->insert($params)) {
            return $this->makeErrorResponse($taskApi);
        }

        return $this->makeSucceedResponse($taskApi, [
            'identifier' => $taskApi->task->identifier,
        ]);
    }

    /**
     * タスクの更新処理
     *
     * @param $identifier
     * @param $params
     * @return array
     */
    private function putTask($identifier, $params)
    {
        $taskApi = new TaskAPI($this->user->id, TaskAPI::SCENARIO_UPDATE);
        $params['identifier'] = $identifier;

        if (!$taskApi->update($params)) {
            return $this->makeErrorResponse($taskApi);
        }

        return $this->makeSucceedResponse($taskApi, [
            'identifier' => $identifier,
        ]);
    }

    /**
     * タスクの削除処理
     *
     * @param $identifier
     * @return array
     */
    private function deleteTask($identifier)
    {
        $taskApi = new TaskAPI($this->user->id, TaskAPI::SCENARIO_DELETE);
        $params = [
            'identifier' => $identifier,
        ];

        if (!$taskApi->delete($params)) {
            return $this->makeErrorResponse($taskApi);
        }

        return $this->makeSucceedResponse($taskApi, [
            'deleted_identifiers' => $taskApi->deletedIdentifiers,
        ]);
    }

    /**
     * 失敗レスポンスを返却する
     *
     * @param TaskAPI $taskApi TaskAPIオブジェクト
     * @return array
     */
    private function makeErrorResponse(TaskAPI $taskApi)
    {
        $this->code    = $taskApi->statusCode();
        $this->message = $taskApi->errorMessage();
        return [];
    }

    /**
     * 成功レスポンスを返却する
     *
     * @param TaskAPI $taskApi TaskAPIオブジェクト
     * @param array $data 返却するデータ
     * @return array
     */
    private function makeSucceedResponse(TaskAPI $taskApi, array $data)
    {
        $this->code = $taskApi->statusCode();
        return $data;
    }
}