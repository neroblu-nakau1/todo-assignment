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
     * @return $this
     */
    public function active()
    {
        return $this->andWhere([
            Task::tableName(). '.is_deleted' => false,
        ]);
    }

    /**
     * @param $userID
     * @return $this
     */
    public function user($userID)
    {
        return $this->andWhere([
            Task::tableName(). '.user_id' => $userID,
        ]);
    }

    /**
     * @param string $identifier
     * @return $this
     */
    public function identifier($identifier)
    {
        return $this->andWhere([
            Task::tableName(). '.identifier' => $identifier,
        ]);
    }

    /**
     * @param string[] $identifiers
     * @return $this
     */
    public function identifiers($identifiers)
    {
        return $this->andWhere([
            'in',
            Task::tableName(). '.identifier',
            $identifiers,
        ]);
    }

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