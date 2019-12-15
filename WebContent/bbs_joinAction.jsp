<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256" %>
<!-- userdao의 클래스 가져옴 -->
<%@ page import="java.io.PrintWriter"%>
<!-- 자바 클래스 사용 -->
<%
	request.setCharacterEncoding("UTF-8");
%>

<!-- 한명의 회원정보를 담는 user클래스를 자바 빈즈로 사용 / scope:페이지 현재의 페이지에서만 사용-->
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userGameID" />
<jsp:setProperty name="user" property="userEmail" />

<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}

		if (userID != null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어있습니다.')");
			script.println("<location.href = 'index.jsp'");
			script.println("</script>");
		}
		
		if (user.getUserID() == null || user.getUserPassword() == null || user.getUserGameID() == null
				|| user.getUserEmail() == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('입력이 안 된 사항이 있습니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else {
			user.setUserEmail(user.getUserEmail() + "@seoultech.ac.kr");
			
			UserDAO userDAO = new UserDAO(); //인스턴스생성
			int result = userDAO.join(user);

			//회원가입 실패
			if (result == -1) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()");
				script.println("</script>");
			}
			//회원가입 성공
			else {
				session.setAttribute("userID", user.getUserID());
				session.setAttribute("userEmail", user.getUserEmail());
				session.setAttribute("userGameID", user.getUserGameID());
				
				PrintWriter script = response.getWriter();
				script.println("<script>");
//				script.println("location.href = 'index.jsp'");
				script.println("location.href = 'emailSendAction.jsp'");
				script.println("</script>");
			}
		}
	%>

</body>
</body>
</html>