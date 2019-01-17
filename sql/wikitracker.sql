IMPORT FROM CSV FILE 'core/demo/wikiticker.csv' INTO wiki(time string, user string, page
  string, channel string, namespace string, comment string, metroCode string,
  cityName string, regionName string, regionIsoCode string, countryName string,
  countryIsoCode string, isAnonymous string, isMinor string, isNew string,
  isRobot string, isUnpatrolled string, delta double, added double, deleted
  double);  

SELECT comment, channel FROM wiki
  WHERE countryIsoCode is not NULL
  ORDER BY channel DESC LIMIT 15;
  
SELECT * FROM
  DIFF
    (SELECT * FROM wiki WHERE deleted > 0.0) outliers,
    (SELECT * FROM wiki WHERE deleted <= 0.0) inliers
  ON *;

SELECT * FROM DIFF (SPLIT wiki WHERE deleted > 0.0) ON *;

SELECT * FROM DIFF (SPLIT wiki WHERE deleted > 0.0)
  ON isRobot, channel, isUnpatrolled, isNew, isMinor, isAnonymous, namespace;

SELECT * FROM DIFF (SPLIT wiki WHERE deleted > 0.0)
  ON *
  WITH MIN SUPPORT 0.10;

SELECT * FROM DIFF (SPLIT wiki WHERE deleted > 0.0)
  ON *
  WITH MIN RATIO 1.25;

SELECT * FROM DIFF (SPLIT wiki WHERE deleted > 0.0)
  ON *
  WITH MIN SUPPORT 0.10 MIN RATIO 1.25;
  -- WITH MIN RATIO 1.25 MIN SUPPORT 0.10 also works

SELECT percentile(deleted) FROM wiki;
SELECT deleted, percentile(deleted) as percentile FROM wiki;
SELECT *, percentile(deleted) as percentile FROM wiki;

SELECT deleted FROM wiki WHERE percentile(deleted) > 0.95;

SELECT * FROM DIFF
    (SPLIT (
      SELECT *, percentile(deleted) as percentile FROM wiki)
    WHERE percentile > 0.95)
  ON isRobot, channel, isUnpatrolled, isNew, isMinor, isAnonymous, namespace
  WITH MIN SUPPORT 0.10;  