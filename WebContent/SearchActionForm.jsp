<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <% request.setCharacterEncoding("utf-8");%>
    <jsp:useBean id="summonerData" class="Resources.SummonerDatas">
    	<jsp:setProperty name="summonerData" property="name"/>
    </jsp:useBean>
    
    <h2><font color="white">자바빈 체크하기</font></h2>
   <font color="white">입력된 이름은 <jsp:getProperty name="summonerData" property="name"/>입니다.</font>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
		body{
			background-image : url(bundle.jpg);
			background-size : 500px;
			background-repeat : no-repeat;
		}
	</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>소환사 <jsp:getProperty name="summonerData" property="name"/>님의 최근 전적</title>
</head>
<body>
</body>
</html>