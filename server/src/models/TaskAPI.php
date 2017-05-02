<?php
namespace app\models;

use app\helpers\StringHelper;
use Yii;
use yii\base\Model;

/**
 * タスクAPIの処理を行うモデル
 *
 * @package app\models
 *
 * @property Task $task
 */
class TaskAPI extends Model
{
    const SCENARIO_SELECT = 'select';
    const SCENARIO_INSERT = 'insert';
    const SCENARIO_UPDATE = 'update';
    const SCENARIO_DELETE = 'delete';

    const ERRMSG_REQUIRED          = '{attribute}は必須です';
    const ERRMSG_MUST_INTEGER      = '{attribute}は整数である必要があります';
    const ERRMSG_MAX_LEN_TEXT      = '{attribute}は{max, number}文字以内である必要があります';
    const ERRMSG_DATE_FORMAT       = '{attribute}の日付形式が違います(例: 2017-04-20)';
    const ERRMSG_OUT_BOUND_INTEGER = '{attribute}は{min, number}〜{max, number}の整数である必要があります';
    const ERRMSG_NOTFOUND          = '対象のタスクが見つかりませんでした';

    const HTTP_OK           = 200;
    const HTTP_CREATED      = 201;
    const HTTP_BADREQUEST   = 400;
    const HTTP_UNAUTHORIZED = 401;
    const HTTP_NOTFOUND     = 404;
    const HTTP_ERROR        = 500;

    public $user_id;
    public $identifier;
    public $title;
    public $date;
    public $priority;
    public $memo;
    public $is_completed;

    public $task;
    public $deletedIdentifiers = [];

    private $code = self::HTTP_OK;

    /**
     * コンストラクタ
     * @param integer $userID ユーザID
     * @param string $scenario シナリオ
     * @param array $config
     */
    public function __construct($userID, $scenario, array $config = [])
    {
        $this->user_id = $userID;
        $this->setScenario($scenario);
        parent::__construct($config);
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [
                ['user_id'],
                'required',
                'message' => $this->t(self::ERRMSG_REQUIRED),
            ],
            [
                ['title', 'date', 'priority', 'is_completed'],
                'required',
                'message' => $this->t(self::ERRMSG_REQUIRED),
                'on' => [self::SCENARIO_INSERT, self::SCENARIO_UPDATE],
            ],
            [
                ['user_id', 'is_completed'],
                'integer',
                'message' => $this->t(self::ERRMSG_MUST_INTEGER),
            ],
            [
                ['identifier'],
                'string',
                'message' => $this->t(self::ERRMSG_REQUIRED),
                'on' => [self::SCENARIO_UPDATE, self::SCENARIO_DELETE],
            ],
            [
                ['title'],
                'string',
                'max' => 128,
                'tooLong' => $this->t(self::ERRMSG_MAX_LEN_TEXT),
            ],
            [
                ['date'],
                'date',
                'format' => 'Y-m-d',
                'message' => $this->t(self::ERRMSG_DATE_FORMAT),
            ],
            [
                ['priority'],
                'integer',
                'min' => 1, 'tooSmall' => $this->t(self::ERRMSG_OUT_BOUND_INTEGER),
                'max' => 4, 'tooBig'   => $this->t(self::ERRMSG_OUT_BOUND_INTEGER),
            ],
            [
                ['memo'],
                'string',
            ],
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'user_id'      => $this->t('ユーザーID'),
            'identifier'   => $this->t('識別文字列'),
            'title'        => $this->t('タイトル'),
            'date'         => $this->t('期限'),
            'priority'     => $this->t('重要度'),
            'memo'         => $this->t('メモ'),
            'is_completed' => $this->t('完了フラグ'),
        ];
    }

    /**
     * 有効なデータの全取得
     * @return Task[]|array
     */
    public function fetchAll()
    {
        return Task::find()
            ->active()
            ->user($this->user_id)
            ->all();
    }

    /**
     * データの挿入
     * @param array $params パラメータ
     * @return bool 成功/失敗
     */
    public function insert(array $params)
    {
        if (!$this->load($params) || !$this->validate()) {
            $this->code = self::HTTP_BADREQUEST;
            return false;
        }

        $task = $this->bindToTask(new Task());
        $task->identifier = StringHelper::generateIdentifier();

        if (!$task->save()) {
            $this->addErrors($task->errors);
            $this->code = self::HTTP_ERROR;
            return false;
        }

        $this->code = self::HTTP_CREATED;
        $this->task = $task;
        return true;
    }

    /**
     * データの更新
     * @param array $params パラメータ
     * @return bool 成功/失敗
     */
    public function update(array $params)
    {
        if (!$this->load($params) || !$this->validate()) {
            $this->code = self::HTTP_BADREQUEST;
            return false;
        }

        $task = Task::find()
            ->active()
            ->user($this->user_id)
            ->identifier($params['identifier'])
            ->one();

        if (!$task) {
            $this->addError('identifier', $this->t(self::ERRMSG_NOTFOUND));
            $this->code = self::HTTP_NOTFOUND;
            return false;
        }

        $task = $this->bindToTask($task);
        if (!$task->save()) {
            $this->addErrors($task->errors);
            $this->code = self::HTTP_ERROR;
            return false;
        }

        $this->task = $task;
        return true;
    }

    /**
     * @param $params
     * @return bool
     */
    public function delete(array $params)
    {
        if (!$this->load($params) || !$this->validate()) {
            $this->code = self::HTTP_BADREQUEST;
            return false;
        }

        $identifiers = StringHelper::explodeByComma($params['identifier']);
        if (!$identifiers) {
            return true; // エラーではないのでtrue
        }

        Task::updateAll([
            Task::tableName(). '.is_deleted' => true,
        ], ['and',
            ['in', Task::tableName(). '.identifier', $identifiers,],
            [Task::tableName(). '.user_id' => $this->user_id],
        ]);

        $this->deletedIdentifiers = $identifiers;
        return true;
    }

    /**
     * エラー文言を取得する
     * @return string エラー文言
     */
    public function errorMessage()
    {
        foreach ($this->firstErrors as $attribute => $message) {
            return $message;
        }
        return '';
    }

    /**
     * HTTPステータスコードを取得する
     * @return int HTTPステータスコード
     */
    public function statusCode()
    {
        return $this->code;
    }

    /**
     * 指定したタスクに自身の情報をバインドする
     * @param Task $task 対象のタスク
     * @return Task バインドされたタスク
     */
    private function bindToTask(Task $task)
    {
        $task->user_id      = $this->user_id;
        $task->title        = $this->title;
        $task->date         = $this->date;
        $task->priority     = (int)$this->priority;
        $task->memo         = $this->memo;
        $task->is_completed = (int)$this->is_completed;
        return $task;
    }

    /**
     * Yii::t()のラップメソッド
     * @param string $message エラー文言
     * @return string Yii::t()をかけた文言
     */
    private function t($message)
    {
        return Yii::t('app', $message);
    }

    /**
     * @inheritdoc
     */
    public function formName() { return ''; }
}