<?php
namespace app\models\queries;

use app\models\User;
use yii\db\ActiveQuery;

/**
 * Class UserQuery
 * @package app\models
 */
class UserQuery extends ActiveQuery
{
    /**
     * @param $token
     * @return $this
     */
    public function token($token)
    {
        return $this->andWhere([
            User::tableName(). '.token' => $token,
        ]);
    }

    /**
     * @inheritdoc
     * @return User[]|array
     */
    public function all($db = null)
    {
        return parent::all($db);
    }

    /**
     * @inheritdoc
     * @return User|array|null
     */
    public function one($db = null)
    {
        return parent::one($db);
    }
}