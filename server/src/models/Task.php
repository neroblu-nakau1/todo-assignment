<?php
namespace app\models;

use app\models\queries\TaskQuery;
use Yii;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;

/**
 * タスク
 *
 * @property integer $id
 * @property integer $user_id
 * @property string  $title
 * @property string  $date
 * @property integer $priority
 * @property string  $memo
 * @property integer $is_deleted
 * @property integer $create_at
 * @property integer $updated_at
 */
class Task extends ActiveRecord
{
    /**
     * @inheritdoc
     */
    public function behaviors()
    {
        return [TimestampBehavior::className()];
    }

    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return 'task';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['user_id', 'title', 'date', 'priority'], 'required'],
            [['user_id', 'is_deleted'], 'integer'],
            [['priority'], 'integer', 'max' => 4],
            [['memo'], 'string'],
            [['title'], 'string', 'max' => 128],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id'         => Yii::t('app', 'ID'),
            'user_id'    => Yii::t('app', 'ユーザーID'),
            'title'      => Yii::t('app', 'タイトル'),
            'date'       => Yii::t('app', '期限'),
            'priority'   => Yii::t('app', '重要度'),
            'memo'       => Yii::t('app', 'メモ'),
            'is_deleted' => Yii::t('app', '削除フラグ'),
            'created_at' => Yii::t('app', '作成日時'),
            'updated_at' => Yii::t('app', '更新日時'),
        ];
    }

    /**
     * @return TaskQuery
     */
    public static function find()
    {
        return new TaskQuery(get_called_class());
    }

    /**
     * @param string|null $className
     * @return \yii\db\ActiveQuery
     */
    public function getUser($className = null)
    {
        return $this->hasOne($className ?? User::className(), ['id' => 'user_id']);
    }
}
