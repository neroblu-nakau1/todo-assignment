<?php
namespace app\models\queries;

use app\models\Task;
use yii\db\ActiveQuery;

/**
 * Class TaskQuery
 * @package app\models
 */
class TaskQuery extends ActiveQuery
{
    /**
     * @inheritdoc
     * @return Task[]|array
     */
    public function all($db = null)
    {
        return parent::all($db);
    }

    /**
     * @inheritdoc
     * @return Task|array|null
     */
    public function one($db = null)
    {
        return parent::one($db);
    }
}