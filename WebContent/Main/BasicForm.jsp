<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
	body{
		background-color : #5CD1E5;
		background-image : url(mainimage.jpg);
		background-size : 100%;
	}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>롤 전적검색 사이트</title>
</head>
<body>
	<form style="text-align:center; method="post" action="SearchSummoner.jsp">
		<p style="margin: 450px -40px 0px 0px;">
		<input type="text" name="name" size="40" style="padding:5px 0px 5px 10px; height:30px;" placeholder="소환사명을 입력하세요!">
		<input type="submit" value="소환사 검색" size="40" style="height:40px;">
		</p>
	</form>
</body>
</html>