<?php
use yii\db\Migration;

/**
 * Class m170427_122024_init
 */
class m170427_122024_init extends Migration
{
    public function up()
    {
        $tableOptions = null;
        if ($this->db->driverName === 'mysql') {
            $tableOptions = 'CHARACTER SET utf8 COLLATE utf8_general_ci ENGINE=InnoDB';
        }

        // ユーザー
        $this->createTable('user', [
            'id'         => $this->primaryKey()->unsigned()->comment('ID'),
            'token'      => $this->string(32)->notNull()->unique()->comment('トークン'),
            'is_deleted' => $this->boolean()->notNull()->defaultValue(false)->comment('削除フラグ'),
            'created_at' => $this->integer()->unsigned()->notNull()->comment('作成日時'),
            'updated_at' => $this->integer()->unsigned()->comment('更新日時'),
        ], $tableOptions);
        $this->createIndex('idx-user-token', 'user', 'token');

        // タスク
        $this->createTable('task', [
            'id'         => $this->primaryKey()->unsigned()->comment('ID'),
            'user_id'    => $this->integer()->unsigned()->notNull()->comment('ユーザーID'),
            'title'      => $this->string(128)->notNull()->comment('タイトル'),
            'date'       => $this->date()->notNull()->comment('期限'),
            'priority'   => $this->integer(1)->notNull()->defaultValue(1)->comment('重要度'),
            'memo'       => $this->text()->comment('メモ'),
            'is_deleted' => $this->boolean()->notNull()->defaultValue(false)->comment('削除フラグ'),
            'created_at' => $this->integer()->unsigned()->notNull()->comment('作成日時'),
            'updated_at' => $this->integer()->unsigned()->comment('更新日時'),
        ], $tableOptions);
        $this->addForeignKey('fk-task-user_id-user-id', 'task', 'user_id', 'user', 'id');
    }

    public function down()
    {
        $this->dropTableIfExists('task');
        $this->dropTableIfExists('user');
    }

    /**
     * テーブルが存在する場合のみDropする
     * @param string $tableName
     */
    private function dropTableIfExists($tableName)
    {
        if (Yii::$app->db->schema->getTableSchema($tableName)) {
            $this->dropTable($tableName);
        }
    }
}