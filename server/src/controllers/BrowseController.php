<?php
namespace app\controllers;

use app\models\Task;
use yii\web\Controller;

class BrowseController extends Controller
{
    /**
     * @return string
     */
    public function actionIndex()
    {
        return $this->render('index', [
            'tasks' => Task::find()->all(),
        ]);
    }
}