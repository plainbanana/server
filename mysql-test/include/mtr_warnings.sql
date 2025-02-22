-- Copyright (c) 2008, 2011, Oracle and/or its affiliates
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; version 2 of the License.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software Foundation,
-- 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335  USA

delimiter ||;

use mtr||

--
-- Create table where testcases can insert patterns to
-- be suppressed
--
CREATE TABLE test_suppressions (
  pattern VARCHAR(255)
) ENGINE=MyISAM||


--
-- Declare a trigger that makes sure
-- no invalid patterns can be inserted
-- into test_suppressions
--
SET @character_set_client_saved = @@character_set_client||
SET @character_set_results_saved = @@character_set_results||
SET @collation_connection_saved = @@collation_connection||
SET @@character_set_client = latin1||
SET @@character_set_results = latin1||
SET @@collation_connection = latin1_swedish_ci||
/*!50002
CREATE DEFINER=root@localhost TRIGGER ts_insert
BEFORE INSERT ON test_suppressions
FOR EACH ROW BEGIN
  DECLARE dummy INT;
  SELECT "" REGEXP NEW.pattern INTO dummy;
END
*/||
SET @@character_set_client = @character_set_client_saved||
SET @@character_set_results = @character_set_results_saved||
SET @@collation_connection = @collation_connection_saved||


--
-- Load table with patterns that will be suppressed globally(always)
--
CREATE TABLE global_suppressions (
  pattern VARCHAR(255)
) ENGINE=MyISAM||


-- Declare a trigger that makes sure
-- no invalid patterns can be inserted
-- into global_suppressions
--
SET @character_set_client_saved = @@character_set_client||
SET @character_set_results_saved = @@character_set_results||
SET @collation_connection_saved = @@collation_connection||
SET @@character_set_client = latin1||
SET @@character_set_results = latin1||
SET @@collation_connection = latin1_swedish_ci||
/*!50002
CREATE DEFINER=root@localhost TRIGGER gs_insert
BEFORE INSERT ON global_suppressions
FOR EACH ROW BEGIN
  DECLARE dummy INT;
  SELECT "" REGEXP NEW.pattern INTO dummy;
END
*/||
SET @@character_set_client = @character_set_client_saved||
SET @@character_set_results = @character_set_results_saved||
SET @@collation_connection = @collation_connection_saved||



--
-- Insert patterns that should always be suppressed
--
INSERT INTO global_suppressions VALUES
 (".SELECT UNIX_TIMESTAMP... failed on master"),
 ("Aborted connection"),
 ("Client requested master to start replication from impossible position"),
 ("Could not find first log file name in binary log"),
 ("Enabling keys got errno"),
 ("Error reading master configuration"),
 ("Error reading packet"),
 ("Event Scheduler"),
 ("Failed to open log"),
 ("Failed to open the existing master info file"),
 ("Forcing shutdown of [0-9]* plugins"),

 /*
   Due to timing issues, it might be that this warning
   is printed when the server shuts down and the
   computer is loaded.
 */

 ("Got error [0-9]* when reading table"),
 ("Incorrect information in file"),
 ("InnoDB: Warning: we did not need to do crash recovery"),
 /*("Invalid \\(old\\?\\) table or database name"),*/
 ("Lock wait timeout exceeded"),
 ("Log entry on master is longer than max_allowed_packet"),
 ("unknown option '--loose-"),
 ("unknown variable 'loose-"),
 ("You have forced lower_case_table_names to 0 through a command-line option"),
 ("Setting lower_case_table_names=2"),
 ("Neither --relay-log nor --relay-log-index were used"),
 ("Query partially completed"),
 ("Slave I.O thread aborted while waiting for relay log"),
 ("Slave SQL thread is stopped because UNTIL condition"),
 ("Slave SQL thread retried transaction"),
 ("Slave \\(additional info\\)"),
 ("Slave: .*Duplicate column name"),
 ("Slave: .*master may suffer from"),
 ("Slave: According to the master's version"),
 ("Slave: Column [0-9]* type mismatch"),
 ("Slave: Error .* doesn't exist"),
 ("Slave: Error .*Unknown table"),
 ("Slave: Error in Write_rows event: "),
 ("Slave: Field .* of table .* has no default value"),
 ("Slave: Field .* doesn't have a default value"),
 ("Slave: Query caused different errors on master and slave"),
 ("Slave: Table .* doesn't exist"),
 ("Slave: Table width mismatch"),
 ("Slave: The incident LOST_EVENTS occurred on the master"),
 ("Slave: Unknown error.* 1105"),
 ("Slave: Can't drop database.* database doesn't exist"),
 ("Warning:\s+One can only use the --user.*root"),
 ("Warning:\s+Table:.* on (delete|rename)"),
 ("You have an error in your SQL syntax"),
 ("deprecated"),
 ("description of time zone"),
 ("equal MariaDB server ids"),
 ("error .*connecting to master"),
 ("error reading log entry"),
 ("lower_case_table_names is set"),
 ("skip-name-resolve mode"),
 ("slave SQL thread aborted"),
 ("Slave: .*Duplicate entry"),

 ("Statement may not be safe to log in statement format"),

 /* innodb foreign key tests that fail in ALTER or RENAME produce this */
 ("InnoDB: Error: in ALTER TABLE `test`.`t[123]`"),
 ("InnoDB: Error: in RENAME TABLE table `test`.`t1`"),
 ("InnoDB: Error: table `test`.`t[123]` .*does not exist in the InnoDB internal"),
 ("InnoDB: Warning: semaphore wait:"),

 /* MDEV-28976: Tests that kill the server do not ensure that the
 old process has terminated before starting a new one */
 ("InnoDB: Unable to lock"),

 /*
   BUG#32080 - Excessive warnings on Solaris: setrlimit could not
   change the size of core files
  */
 ("setrlimit could not change the size of core files to 'infinity'"),

 ("The slave I.O thread stops because a fatal error is encountered when it try to get the value of SERVER_ID variable from master."),

 /*It will print a warning if server is run without --explicit_defaults_for_timestamp.*/
 ("TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details)*"),

 /* Added 2009-08-XX after fixing Bug #42408 */

 ("Although a path was specified for the .* option, log tables are used"),
 ("Backup: Operation aborted"),
 ("Restore: Operation aborted"),
 ("Restore: The grant .* was skipped because the user does not exist"),
 ("The path specified for the variable .* is not a directory or cannot be written:"),
 ("Master server does not support or not configured semi-sync replication, fallback to asynchronous"),
 (": The MariaDB server is running with the --secure-backup-file-priv option so it cannot execute this statement"),
 ("Slave: Unknown table 't1' error.* 1051"),

 /* Maria storage engine dependent tests */

 /* maria-recovery.test has warning about missing log file */
 ("File '.*maria_log.000.*' not found \\(Errcode: 2\\)"),
 /* and about marked-corrupted table */
 ("Table '..mysqltest.t_corrupted1' is crashed, skipping it. Please repair"),
 /* maria-recover.test corrupts tables on purpose */
 ("Checking table:   '..mysqltest.t_corrupted2'"),
 ("Table '..mysqltest.t_corrupted2' is marked as crashed and should be"),
 ("Incorrect key file for table '..mysqltest.t_corrupted2.MAI'"),

 /* Messages from valgrind */
 ("==[0-9]*== Memcheck,"),
 ("==[0-9]*== Copyright"),
 ("==[0-9]*== Using"),
 ("==[0-9]*== For more details"),
 /* This comes with innodb plugin tests */
 ("==[0-9]*== Warning: set address range perms: large range"),
 /* valgrind-3.5.0 dumps this */
 ("==[0-9]*== Command: "),

 /* valgrind warnings: invalid file descriptor -1 in syscall
    write()/read(). Bug #50414 */
 ("==[0-9]*== Warning: invalid file descriptor -1 in syscall write()"),
 ("==[0-9]*== Warning: invalid file descriptor -1 in syscall read()"),

 /*
   Transient network failures that cause warnings on reconnect.
   BUG#47743 and BUG#47983.
 */
 ("Slave I/O: Get master SERVER_ID failed with error:.*"),
 ("Slave I/O: Get master clock failed with error:.*"),
 ("Slave I/O: Get master COLLATION_SERVER failed with error:.*"),
 ("Slave I/O: Get master TIME_ZONE failed with error:.*"),
 ("Slave I/O: The slave I/O thread stops because a fatal error is encountered when it tried to SET @master_binlog_checksum on master.*"),
 ("Slave I/O: Get master BINLOG_CHECKSUM failed with error.*"),
 ("Slave I/O: Notifying master by SET @master_binlog_checksum= @@global.binlog_checksum failed with error.*"),
 ("Slave I/O: Setting master-side filtering of @@skip_replication failed with error:.*"),
 ("Slave I/O: Setting @mariadb_slave_capability failed with error:.*"),
 ("Slave I/O: Get master @@GLOBAL.gtid_domain_id failed with error.*"),
 ("Slave I/O: Setting @slave_connect_state failed with error.*"),
 ("Slave I/O: Setting @slave_gtid_strict_mode failed with error.*"),
 ("Slave I/O: Setting @slave_gtid_ignore_duplicates failed with error.*"),
 ("Slave I/O: Setting @slave_until_gtid failed with error.*"),
 ("Slave I/O: Get master GTID position failed with error.*"),

 /*
   MDEV-12501 -- set --maturity-level by default
 */
 ("Plugin .* is of maturity level .* while the server is .*"),

 ("THE_LAST_SUPPRESSION")||


--
-- Procedure that uses the above created tables to check
-- the servers error log for warnings
--
CREATE DEFINER=root@localhost PROCEDURE check_warnings(OUT result INT)
BEGIN
  DECLARE `pos` bigint unsigned;

  -- Don't write these queries to binlog
  SET SQL_LOG_BIN=0, SQL_SAFE_UPDATES=0;

  --
  -- Remove mark from lines that are suppressed by global suppressions
  --
  UPDATE error_log el, global_suppressions gs
    SET suspicious=0
      WHERE el.suspicious=1 AND el.line REGEXP gs.pattern;

  --
  -- Remove mark from lines that are suppressed by test specific suppressions
  --
  UPDATE error_log el, test_suppressions ts
    SET suspicious=0
      WHERE el.suspicious=1 AND el.line REGEXP ts.pattern;

  --
  -- Get the number of marked lines and return result
  --
  SELECT COUNT(*) INTO @num_warnings FROM error_log
    WHERE suspicious=1;

  IF @num_warnings > 0 THEN
    SELECT line
        FROM error_log WHERE suspicious=1;
    --SELECT * FROM test_suppressions;
    -- Return 2 -> check failed
    SELECT 2 INTO result;
  ELSE
    -- Return 0 -> OK
    SELECT 0 INTO RESULT;
  END IF;

  -- Cleanup for next test
  TRUNCATE test_suppressions;
  DROP TABLE error_log;

END||

--
-- Declare a procedure testcases can use to insert test
-- specific suppressions
--
/*!50001
CREATE DEFINER=root@localhost
PROCEDURE add_suppression(pattern VARCHAR(255))
BEGIN
  INSERT INTO test_suppressions (pattern) VALUES (pattern);
  FLUSH NO_WRITE_TO_BINLOG TABLE test_suppressions;
END
*/||


