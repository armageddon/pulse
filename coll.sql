-- MySQL dump 10.13  Distrib 5.1.38, for apple-darwin10.0.0 (i386)
--
-- Host: localhost    Database: collections2_development
-- ------------------------------------------------------
-- Server version	5.1.38

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories_posts`
--

DROP TABLE IF EXISTS `categories_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories_posts` (
  `post_id` int(11) NOT NULL DEFAULT '0',
  `category_id` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories_posts`
--

LOCK TABLES `categories_posts` WRITE;
/*!40000 ALTER TABLE `categories_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `categories_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL DEFAULT '0',
  `user_id` varchar(30) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,4,'12','testing the comments','2010-06-15 17:55:59');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favourites`
--

DROP TABLE IF EXISTS `favourites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favourites` (
  `id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `post_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favourites`
--

LOCK TABLES `favourites` WRITE;
/*!40000 ALTER TABLE `favourites` DISABLE KEYS */;
INSERT INTO `favourites` VALUES (NULL,3,2),(NULL,12,4);
/*!40000 ALTER TABLE `favourites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forumposts`
--

DROP TABLE IF EXISTS `forumposts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forumposts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `header` varchar(200) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `created_at` datetime NOT NULL,
  `topic_id` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forumposts`
--

LOCK TABLES `forumposts` WRITE;
/*!40000 ALTER TABLE `forumposts` DISABLE KEYS */;
/*!40000 ALTER TABLE `forumposts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `forumtopics`
--

DROP TABLE IF EXISTS `forumtopics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forumtopics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_name` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `forumtopics`
--

LOCK TABLES `forumtopics` WRITE;
/*!40000 ALTER TABLE `forumtopics` DISABLE KEYS */;
/*!40000 ALTER TABLE `forumtopics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `friendships`
--

DROP TABLE IF EXISTS `friendships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friendships` (
  `id` int(11) DEFAULT NULL,
  `friend_stage` varchar(255) DEFAULT NULL,
  `friend_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `friendships`
--

LOCK TABLES `friendships` WRITE;
/*!40000 ALTER TABLE `friendships` DISABLE KEYS */;
INSERT INTO `friendships` VALUES (NULL,'invite',2,3),(NULL,'invite',3,16);
/*!40000 ALTER TABLE `friendships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) DEFAULT NULL,
  `post_id` int(11) DEFAULT NULL,
  `grouped_to` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups_posts`
--

DROP TABLE IF EXISTS `groups_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) DEFAULT NULL,
  `post_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups_posts`
--

LOCK TABLES `groups_posts` WRITE;
/*!40000 ALTER TABLE `groups_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos`
--

DROP TABLE IF EXISTS `photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL DEFAULT '0',
  `pic` varchar(30) NOT NULL DEFAULT '',
  `caption` text NOT NULL,
  `created_at` datetime NOT NULL,
  `poster_image` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photos`
--

LOCK TABLES `photos` WRITE;
/*!40000 ALTER TABLE `photos` DISABLE KEYS */;
INSERT INTO `photos` VALUES (1,1,'picture-81.png','afsdfsdfdfaffss','2009-01-30 01:55:41',1),(2,1,'Picture_4.jpg','dcvxxcvcxvcvcxvxczv','2009-01-30 01:56:13',1),(3,2,'04_1.jpg','i like this one','2009-01-30 10:56:20',1),(4,2,'127.jpg','hey bokkie bokkie','2009-01-30 10:56:39',0),(5,2,'09_ORAVA.jpg','ariba ariva','2009-01-30 10:57:00',0),(6,3,'pendant1.jpg','Pendant','2010-06-15 14:21:42',1),(7,3,'image_large4.jpeg','sdfds','2010-06-15 15:55:23',1),(8,3,'image2.png','dddd','2010-06-15 15:56:07',1),(9,3,'image.png','vvxcxvxv','2010-06-15 15:56:20',1),(10,4,'Picture_1.jpg',' cxvcxvcxv','2010-06-15 15:57:26',1),(11,4,'image_large8.jpeg','bird','2010-06-15 15:57:39',1),(12,5,'car-yellow-2000.gif','big image','2010-06-15 20:37:55',1),(13,5,'mamma_blu2_1000x1000.gif','mamma 1000x1000','2010-06-15 20:38:27',1),(14,5,'mamma_blu.png','blu mamma','2010-06-15 20:42:26',1),(15,5,'1aandy.jpg','andy','2010-06-15 20:42:57',1);
/*!40000 ALTER TABLE `photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL DEFAULT '',
  `post` text NOT NULL,
  `created_at` datetime NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `modified_at` date NOT NULL DEFAULT '0000-00-00',
  `visit_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (1,'Test collection 1','Et pellentesque nibh metus. Elit pellentesque et, consectetuer at duis vitae vehicula. Metus consequat nulla pulvinar at, condimentum consequuntur nunc justo, interdum rutrum pede aliquam. Pretium suscipit augue lorem duis, commodo viverra velit quis felis venenatis mauris, morbi interdum tincidunt urna in dictum. Eros tenetur nunc pulvinar tincidunt, pulvinar vitae mattis turpis mi, sed tellus sed arcu quisque cursus, at vivamus elit praesent sem. Lobortis imperdiet nec orci justo scelerisque. Arcu placeat, felis condimentum velit, erat eget, turpis adipiscing in class vestibulum. Risus sed justo nec pede sed leo, etiam condimentum mattis ut.','2009-01-30 01:56:13',2,'2009-01-30',NULL),(2,'collection2','asdasdad sddaddadad dadad','2009-01-30 10:57:00',2,'2009-02-02',7),(3,'sadsdds','asdsddsadsd','2010-06-15 15:56:20',3,'2010-06-15',22),(4,'new one','ssvcxvx cxvxcv s;prem Et pellentesque nibh metus. Elit pellentesque et, consectetuer at duis vitae vehicula. Metus consequat nulla pulvinar at, condimentum consequuntur nunc justo, interdum rutrum pede aliquam. Pretium suscipit augue lorem duis, commodo viverra velit quis felis venenatis mauris, morbi interdum tincidunt urna in dictum. Eros tenetur nunc pulvinar tincidunt, pulvinar vitae mattis turpis mi, sed tellus sed arcu quisque cursus, at vivamus elit praesent sem. Lobortis imperdiet nec orci justo scelerisque. Arcu placeat, felis condimentum velit, erat eget, turpis adipiscing in class vestibulum. Risus sed justo nec pede sed leo, etiam condimentum mattis ut.','2010-06-15 15:57:39',3,'2010-06-15',17),(5,'Test Collect','Et pellentesque nibh metus. Elit pellentesque et, consectetuer at duis vitae vehicula. Metus consequat nulla pulvinar at, condimentum consequuntur nunc justo, interdum rutrum pede aliquam. Pretium suscipit augue lorem duis, commodo viverra velit quis felis venenatis mauris, morbi interdum tincidunt urna in dictum. Eros tenetur nunc pulvinar tincidunt, pulvinar vitae mattis turpis mi, sed tellus sed arcu quisque cursus, at vivamus elit praesent sem. Lobortis imperdiet nec orci justo scelerisque. Arcu placeat, felis condimentum velit, erat eget, turpis adipiscing in class vestibulum. Risus sed justo nec pede sed leo, etiam condimentum mattis ut.','2010-06-15 20:42:57',12,'2010-06-15',4),(6,'lkjhljkh','kllkj','2010-06-17 12:08:57',16,'2010-06-17',1);
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profile`
--

DROP TABLE IF EXISTS `profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `about_me` text,
  `interests` text,
  `city` varchar(255) DEFAULT NULL,
  `pic` varchar(255) DEFAULT NULL,
  `notify` tinyint(1) DEFAULT NULL,
  `hide` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profile`
--

LOCK TABLES `profile` WRITE;
/*!40000 ALTER TABLE `profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `profiles`
--

DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `surname` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `about_me` varchar(255) DEFAULT NULL,
  `interests` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `pic` varchar(255) DEFAULT NULL,
  `notify` tinyint(1) DEFAULT '0',
  `hide` tinyint(1) DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `confirmed` tinyint(1) DEFAULT NULL,
  `dispaly_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `profiles`
--

LOCK TABLES `profiles` WRITE;
/*!40000 ALTER TABLE `profiles` DISABLE KEYS */;
INSERT INTO `profiles` VALUES (1,'george','gally','','Et pellentesque nibh metus. Elit pellentesque et, consectetuer at duis vitae vehicula. Metus consequat nulla pulvinar at, condimentum consequuntur nunc justo, interdum rutrum pede aliquam. Pretium suscipit augue lorem duis, commodo viverra velit quis feli',NULL,'tokyo',NULL,0,0,2,NULL,NULL),(2,'George','Gally','www.radarboy.com','Out & about. No doubt.','','Berlin','image_large4.jpeg',0,0,3,NULL,NULL),(3,'bob','miyagi','radarboy.com','dsadsadsadsdsad','blogging','','Picture_1.jpg',0,0,12,NULL,NULL);
/*!40000 ALTER TABLE `profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ratings`
--

DROP TABLE IF EXISTS `ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rating` int(11) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `rateable_type` varchar(15) NOT NULL DEFAULT '',
  `rateable_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_ratings_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ratings`
--

LOCK TABLES `ratings` WRITE;
/*!40000 ALTER TABLE `ratings` DISABLE KEYS */;
INSERT INTO `ratings` VALUES (1,3,'2009-01-30 02:00:28','Post',1,0),(2,4,'2009-02-02 08:56:33','Post',2,0),(3,5,'2010-06-15 15:37:46','Post',2,0),(4,4,'2010-06-15 15:58:13','Post',3,0),(5,3,'2010-06-15 18:01:59','Post',4,0),(6,3,'2010-06-17 12:09:48','Post',2,0),(7,3,'2010-06-17 12:09:49','Post',2,0),(8,2,'2010-06-17 12:09:51','Post',2,0),(9,2,'2010-06-17 12:09:51','Post',2,0);
/*!40000 ALTER TABLE `ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_info`
--

DROP TABLE IF EXISTS `schema_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_info` (
  `version` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_info`
--

LOCK TABLES `schema_info` WRITE;
/*!40000 ALTER TABLE `schema_info` DISABLE KEYS */;
INSERT INTO `schema_info` VALUES (15);
/*!40000 ALTER TABLE `schema_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taggings`
--

DROP TABLE IF EXISTS `taggings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `taggable_type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taggings`
--

LOCK TABLES `taggings` WRITE;
/*!40000 ALTER TABLE `taggings` DISABLE KEYS */;
INSERT INTO `taggings` VALUES (1,1,1,'Post'),(2,2,1,'Post'),(8,1,2,'Post'),(9,3,2,'Post'),(10,4,2,'Post'),(11,5,2,'Post'),(12,6,2,'Post'),(13,7,2,'Post'),(16,8,3,'Post'),(17,9,3,'Post'),(18,10,3,'Post'),(19,11,4,'Post'),(20,12,4,'Post'),(21,11,4,'Post'),(22,13,4,'Post'),(23,14,4,'Post'),(24,11,4,'Post'),(25,15,5,'Post'),(26,16,5,'Post'),(27,17,5,'Post'),(28,14,6,'Post');
/*!40000 ALTER TABLE `taggings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tags`
--

LOCK TABLES `tags` WRITE;
/*!40000 ALTER TABLE `tags` DISABLE KEYS */;
INSERT INTO `tags` VALUES (1,'test'),(2,'love'),(3,'george'),(4,'should'),(5,'go'),(6,'cape_town'),(7,'tonight'),(8,'bats'),(9,'balls'),(10,'bongs'),(11,'girls'),(12,'hot'),(13,'i'),(14,'like'),(15,'football'),(16,'boozball'),(17,'foozball');
/*!40000 ALTER TABLE `tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `hashed_password` varchar(255) DEFAULT NULL,
  `salt` varchar(255) DEFAULT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `signup_date` timestamp NULL DEFAULT NULL,
  `posts` int(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `activation_code` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (2,'george','cedf3902a33f4ce7109f4746381180a5aad75532','130100660.558236861766569',NULL,NULL,NULL,'george@radarboy.com',NULL),(3,'george_june','f47979ed50df6c88d099ac0c7d78f48d33d2f795','194936000.152256384760166',NULL,NULL,NULL,'robopop@radarboy.com',NULL),(9,'george_june2','b56a2f5890a8df4bf1ae330cfcb65ea2fdbbf345','195518100.43728299937232','george_june2',NULL,NULL,'robopop@radarboy.com',NULL),(10,'george_june3','dc7ebda1ea76f061eb387d046ed9a160654e11d8','189270500.800076186792642','george_june3',NULL,NULL,'robopop4@radarboy.com',NULL),(11,'george_june5','c516467d4385597d128ad27eef89bf2a5fea466b','189748500.354015662920237','george_june5',NULL,NULL,'robopop5@radarboy.com',NULL),(12,'george_june6','6de35f8eee542c9202ffa230a68f426b868159b6','189746600.0259185677136499','george_june6','2010-06-15 16:44:55',NULL,'robopop6@radarboy.com','bccad25d6fccbbff0715c63f2745ae0a42a2790e'),(13,'pierre','aea76ec76d0a5c2898d7e6640804178439b20277','21870312000.11331070152011','pierre',NULL,NULL,'dasda@asdads.com',NULL),(14,'pierrearmageddon','e4e08e2a69fa2488912afe2a89f4e363aca72a65','21876188000.4906114575164','pierrearmageddon','2010-06-16 11:17:55',NULL,'pierre@hellopulse.com','d76f6b27a600850936b9099d92e5e5ee9c820629'),(15,'qqqqqqq','bb78cef1ee1ed9ef355917b21bc3faa9a2637e30','21870100000.253487503514122','qqqqqqq','2010-06-16 16:37:15',NULL,'q@q.com','abddfc133eb1c35e9ce9bfad4c1f702e70c22cd4'),(16,'pepe','55483a36e8028a2b88b4a82e27563d26d6c14780','21738937600.746515315486986','pepe','2010-06-17 11:06:53',NULL,'pepe@pepe.com','b4f2b47db2e06643a150f8f7f0d1511da8e4814a');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-06-24 16:51:32
