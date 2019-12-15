<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>

<%@ page import="Resources.SummonerDatas"%>
<%@ page import="Resources.SummonerDAO"%>

<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>
<!-- 자바 클래스 사용 -->
<%
	request.setCharacterEncoding("UTF-8");
%>

<%
	String userID = null;
	if (request.getParameter("userID") != null) {
		userID = request.getParameter("userID");
	}
	
	String code = null;
	if (request.getParameter("code") != null) {
		code = request.getParameter("code");
	}

	String userGameID = null;
	if (request.getParameter("userGameID") != null) {
		userGameID = request.getParameter("userGameID");
	}
	
	UserDAO userDAO = new UserDAO();
	SummonerDAO summonerDAO = new SummonerDAO();
	
	String userEmail = userDAO.getUserEmail(userID);
	boolean isRight = new SHA256().getSHA256(userEmail).equals(code) ? true : false;
	if (isRight == true) {
		userDAO.setUserEmailChecked(userID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('인증에 성공했습니다.')");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		%>
		<jsp:include page="SearchDataRequest.jsp" flush="false">
			<jsp:param name="userGameID" value="<%=userGameID%>" />
		</jsp:include>
		<%
		System.out.println(userGameID);
		summonerDAO.setIsUser(userGameID);
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.')");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>