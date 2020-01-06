-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 06, 2020 at 10:46 AM
-- Server version: 10.4.6-MariaDB
-- PHP Version: 7.1.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `roleplay`
--

-- --------------------------------------------------------

--
-- Table structure for table `lotteries`
--

CREATE TABLE `lotteries` (
  `id` int(11) NOT NULL,
  `winner` varchar(255) NOT NULL,
  `status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `lotteries`
--

INSERT INTO `lotteries` (`id`, `winner`, `status`) VALUES
(1, 'none', 'open');

-- --------------------------------------------------------

--
-- Table structure for table `lottery_entries`
--

CREATE TABLE `lottery_entries` (
  `id` int(11) NOT NULL,
  `accountid` int(11) NOT NULL,
  `lotto_number` int(11) NOT NULL,
  `lottery_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lottery_entries`
--

INSERT INTO `lottery_entries` (`id`, `accountid`, `lotto_number`, `lottery_id`) VALUES
(2, 35, 77, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `lotteries`
--
ALTER TABLE `lotteries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lottery_entries`
--
ALTER TABLE `lottery_entries`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `lotteries`
--
ALTER TABLE `lotteries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `lottery_entries`
--
ALTER TABLE `lottery_entries`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
