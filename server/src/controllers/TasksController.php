<?php
namespace app\controllers;

use app\models\Task;
use app\models\TaskAPI;
use Yii;

class TasksController extends ApiController
{
    /**
     * タスクの追加処理
     *
     * @return array
     */
    public function actionCreate()
    {
        $taskApi = new TaskAPI($this->user->id, TaskAPI::SCENARIO_INSERT);

        if (!$taskApi->insert(Yii::$app->request->post())) {
            return $this->makeErrorResponse($taskApi);
        }

        return $this->makeSucceedResponse($taskApi, [
            'identifier' => $taskApi->task->identifier,
        ]);
    }

    /**
     * タスクの取得処理
     *
     * @return array
     */
    public function actionRead()
    {
        $taskApi = new TaskAPI($this->user->id, TaskAPI::SCENARIO_SELECT);

        return $this->makeSucceedResponse($taskApi, array_map(function(Task $task) {
            return $task->toArray();
        }, $taskApi->fetchAll()));
    }

    /**
     * タスクの更新処理
     *
     * @param $identifier
     * @return array
     */
    public function actionUpdate($identifier)
    {
        $taskApi = new TaskAPI($this->user->id, TaskAPI::SCENARIO_UPDATE);

        $params = Yii::$app->request->post();
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
     * @param $identifiers
     * @return array
     */
    public function actionDelete($identifiers)
    {
        $taskApi = new TaskAPI($this->user->id, TaskAPI::SCENARIO_DELETE);
        $params = ['identifier' => $identifiers];

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