<?php
namespace app\models;

use app\helpers\StringHelper;
use Yii;
use yii\base\Model;

/**
 * Class TaskAPI
 * @package app\models
 *
 * @property Task $task
 */
class TaskAPI extends Model
{
    const SCENARIO_INSERT = 'insert';
    const SCENARIO_UPDATE = 'update';
    const SCENARIO_DELETE = 'delete';

    public $user_id;
    public $identifier;
    public $title;
    public $date;
    public $priority;
    public $memo;
    public $is_completed;

    public $task;

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [
                ['user_id'],
                'required',
                'message' => Yii::t('app', '{attribute}は必須です')
            ],
            [
                ['title', 'date', 'priority', 'is_completed'],
                'required',
                'message' => Yii::t('app', '{attribute}は必須です'),
                'on' => [self::SCENARIO_INSERT, self::SCENARIO_UPDATE],
            ],
            [
                ['user_id', 'is_completed'],
                'integer',
                'message' => Yii::t('app', '{attribute}は整数である必要があります'),
            ],
            [
                ['identifier'],
                'string',
                'message' => Yii::t('app', '{attribute}は必須です'),
                'on' => [self::SCENARIO_UPDATE],
            ],
            [
                ['title'],
                'string',
                'max' => 128,
                'tooLong' => Yii::t('app', '{attribute}は{max, number}文字以内である必要があります'),
            ],
            [
                ['date'],
                'date',
                'format' => 'Y-m-d',
                'message' => Yii::t('app', '{attribute}の日付形式が違います(例: 2017-04-20)'),
            ],
            [
                ['priority'],
                'integer',
                'min' => 1,
                'tooSmall' => Yii::t('app', '{attribute}は1〜4の整数である必要があります'),
                'max' => 4,
                'tooBig'   => Yii::t('app', '{attribute}は1〜4の整数である必要があります'),
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
            'user_id'      => Yii::t('app', 'ユーザーID'),
            'identifier'   => Yii::t('app', '識別文字列'),
            'title'        => Yii::t('app', 'タイトル'),
            'date'         => Yii::t('app', '期限'),
            'priority'     => Yii::t('app', '重要度'),
            'memo'         => Yii::t('app', 'メモ'),
            'is_completed' => Yii::t('app', '完了フラグ'),
        ];
    }

    /**
     * @param array $params
     * @return bool
     */
    public function insert($params)
    {
        if (!$this->load($params) || !$this->validate()) {
            return false;
        }

        $task = $this->bindToTask(new Task());
        $task->identifier = StringHelper::generateIdentifier();

        if (!$task->save()) {
            $this->addErrors($task->errors);
            return false;
        }

        $this->task = $task;
        return true;
    }

    /**
     * @param $params
     * @return bool
     */
    public function update($params)
    {
        if (!$this->load($params) || !$this->validate()) {
            return false;
        }

        $task = Task::find()->identifier($params['identifier'])->one();
        if (!$task) {
            return false;
        }

        $task = $this->bindToTask($task);
        if (!$task->save()) {
            $this->addErrors($task->errors);
            return false;
        }

        $this->task = $task;
        return true;
    }

    /**
     * @return string
     */
    public function errorMessage()
    {
        foreach ($this->firstErrors as $attribute => $message) {
            return $message;
        }
        return '';
    }

    /**
     * @inheritdoc
     */
    public function formName()
    {
        return '';
    }

    /**
     * @param Task $task
     * @return Task
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
}