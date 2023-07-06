/*
 Navicat Premium Data Transfer

 Source Server         : MyOwn
 Source Server Type    : MySQL
 Source Server Version : 50731
 Source Host           : 39.96.23.94:3306
 Source Schema         : msb_db

 Target Server Type    : MySQL
 Target Server Version : 50731
 File Encoding         : 65001

 Date: 29/07/2021 15:14:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `desc` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `lv` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `createtime` datetime DEFAULT NULL,
  `tags` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----------------------------
-- Records of product
-- ----------------------------
BEGIN;
INSERT INTO `product` VALUES (1, '小米手机', '手机中的战斗机', 3999, '旗舰机', '手机', '2020-10-01 08:00:00', '\"性价比\",\"发烧\",\"不卡顿\"');
INSERT INTO `product` VALUES (2, '小米NFC手机', '支持全功能NFC，手机中的滑翔机', 4999, '旗舰机', '手机', '2020-05-21 08:00:00', '\"性价比\",\"发烧\",\"公交卡\"');
INSERT INTO `product` VALUES (3, 'NFC手机', '手机中的轰炸机', 2999, '高端机', '手机', '2020-06-20 00:00:00', '\"性价比\", \"快充\",\"门禁卡\"');
INSERT INTO `product` VALUES (4, '小米耳机', '耳机中的黄焖鸡', 999, '百元机', '耳机', '2020-06-23 00:00:00', '\"降噪\",\"防水\",\"蓝牙\"');
INSERT INTO `product` VALUES (5, '红米耳机', '耳机中的肯德基', 399, '百元机', '耳机', '2020-07-20 00:00:00', '\"防火\",\"低音炮\",\"听声辨位\"');
INSERT INTO `product` VALUES (6, '小米手机10', '充电贼快掉电更快，超级无敌望远镜，高刷电竞屏', 5999, '旗舰机', '手机', '2020-07-27 00:00:00', '\"120HZ刷新率\",\"120W快充\",\"120倍变焦\"');
INSERT INTO `product` VALUES (7, '挨炮 SE2', '除了CPU，一无是处', 3299, '旗舰机', '手机', '2020-07-21 00:00:00', '\"割韭菜\",\"割韭菜\",\"割新韭菜\"');
INSERT INTO `product` VALUES (8, 'XS Max', '听说要出新款12手机了，终于可以换掉手中的4S了', 4399, '旗舰机', '手机', '2020-08-19 00:00:00', '\"5V1A\",\"4G全网通\",\"大\"');
INSERT INTO `product` VALUES (9, '小米电视', '70寸性价比只选，不要一万八，要不要八千八，只要两千九百九十八', 2998, '高端机', '电视', '2020-08-16 00:00:00', '\"巨馍\",\"家庭影院\",\"游戏\"');
INSERT INTO `product` VALUES (10, '红米电视', '我比上边那个更划算，我也2998，我也70寸，但是我更好看', 2999, '高端机', '电视', '2020-08-28 00:00:00', '\"大片\",\"蓝光8K\",\"超薄\"');
INSERT INTO `product` VALUES (11, '红米电视', '我比上边那个更划算，我也2998，我也70寸，但是我更好看', 2999, '高端机', '电视', '2020-08-28 00:00:00', '\"大片\",\"蓝光8K\",\"超薄\"');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
