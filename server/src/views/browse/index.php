<?php
/* @var $this yii\web\View */
/* @var $tasks \app\models\Task[] */

$this->title = 'データ一覧';
?>
<table class="table table-bordered table-hover">
    <thead>
    <tr>
        <th>ユーザID</th>
        <th>タイトル</th>
        <th>期限</th>
        <th>重要度</th>
        <th>メモ</th>
        <th>完了</th>
        <th>ステータス</th>
    </tr>
    </thead>
    <tbody>
    <?php foreach ($tasks as $task): ?>
    <tr class="<?php if ($task->is_deleted): ?>danger<?php elseif ($task->is_completed): ?>success<?php else: ?><?php endif; ?>">
        <td><?= $task->user_id ?></td>
        <td><?= $task->title ?></td>
        <td><?= date('Y年m月d日', strtotime($task->date)) ?></td>
        <td><?= str_repeat('★', $task->priority) ?></td>
        <td><?= nl2br($task->memo) ?></td>
        <td><?= $task->is_completed ? "完了" : "未完了" ?></td>
        <td><?= $task->is_deleted ? "削除済み" : "" ?></td>
    </tr>
    <?php endforeach; ?>
    </tbody>
    </table>
