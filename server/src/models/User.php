<?php
namespace app\models;

use app\helpers\StringHelper;
use app\models\queries\UserQuery;
use Yii;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;

/**
 * ユーザ
 *
 * @property integer $id
 * @property string  $token
 * @property integer $is_deleted
 * @property integer $create_at
 * @property integer $updated_at
 */
class User extends ActiveRecord
{
    const HEADER_USER_TOKEN = 'X-TodoApp-User-Token';

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
        return 'user';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['token'], 'required'],
            [['is_deleted'], 'integer'],
            [['token'], 'string', 'max' => 32],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id'         => Yii::t('app', 'ID'),
            'token'      => Yii::t('app', 'トークン'),
            'is_deleted' => Yii::t('app', '削除フラグ'),
            'created_at' => Yii::t('app', '作成日時'),
            'updated_at' => Yii::t('app', '更新日時'),
        ];
    }

    /**
     * @return UserQuery
     */
    public static function find()
    {
        return new UserQuery(get_called_class());
    }

    /**
     * @param string|null $className
     * @return \yii\db\ActiveQuery
     */
    public function getTasks($className = null)
    {
        return $this->hasMany($className ?? Task::className(), ['user_id' => 'id']);
    }

    /**
     * ヘッダ情報からユーザ認証
     * @return User
     */
    public function authorize()
    {
        /* @var User $user */
        $user = null;

        $headerToken = Yii::$app->request->headers->get(self::HEADER_USER_TOKEN) ?? "";
        if (!empty($headerToken)) {
            $user = self::find()->token($headerToken)->one();
        }

        if (!$user) {
            $user = new static();
        }

        $user->token = StringHelper::generateIdentifier();
        $user->save();

        return $user;
    }
}
