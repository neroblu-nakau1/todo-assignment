<?php
namespace app\helpers;

/**
 * 文字列ヘルパー
 * @package app\helpers
 */
class StringHelper extends \yii\helpers\StringHelper
{
    /**
     * ID文字列の生成
     * @param int $length
     * @return string
     */
    public static function generateIdentifier($length = 32)
    {
        return substr(base_convert(hash('sha256', uniqid()), 16, 36), 0, $length);
    }

    /**
     * 文字列をカンマで区切って配列化する(値はトリムされ、空の場合はスキップする)
     * @param string $string
     * @return string[]
     */
    public static function explodeByComma($string)
    {
        return self::explode($string, ',', true, true);
    }
}