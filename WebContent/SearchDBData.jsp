<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%@ page import="user.UserDAO"%>

<%@ page import="Resources.SummonerDatas"%>
<%@ page import="Resources.SummonerDAO"%>

<%
	request.setCharacterEncoding("utf-8");
%>
<%
	String name = request.getParameter("userGameID");
	SummonerDatas sd = new SummonerDatas();
	double avg = 0;
	
	SummonerDAO summonerDAO = new SummonerDAO();
	//소환사정보 디비검색
	summonerDAO.setSummonerData(name, sd);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>전적 검색 테이블</title>

  <!-- Custom fonts for this template-->
  <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

  <!-- Page level plugin CSS-->
  <link href="vendor/datatables/dataTables.bootstrap4.css" rel="stylesheet">

  <!-- Custom styles for this template-->
  <link href="css/sb-admin.css" rel="stylesheet">

</head>

<body>

<!-- DataTables Example -->
        <div class="card mb-3">
          <div class="card-header">
            <%=sd.getName() %>님의 전적  </div>
            
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                <thead>
                  <tr>
                    <th>소환사명</th>
                    <th>레벨</th>
                    <th>티어</th>
                    <th>리그포인트</th>
                    <th>랭크 게임 승리</th>
                    <th>랭크 게임 패배</th>
                    <th>플레이한 게임 수</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
					<td><%=sd.getName() %></td>
					<td><%=sd.getSummonerLevel() %></td>
					<td><%=sd.getTier()+" "+sd.getRank() %></td>
					<td><%=sd.getLeaguePoints()+"LP" %></td>
					<td><%=sd.getWin()+"승" %></td>
					<td><%=sd.getLosses()+"패" %></td>
					<td><%="총 "+sd.getTotalGame()+"회" %></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

  <!-- Bootstrap core JavaScript-->
  <script src="vendor/jquery/jquery.min.js"></script>
  <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Page level plugin JavaScript-->
  <script src="vendor/datatables/jquery.dataTables.js"></script>
  <script src="vendor/datatables/dataTables.bootstrap4.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="js/sb-admin.min.js"></script>

  <!-- Demo scripts for this page-->
  <script src="js/demo/datatables-demo.js"></script>
  
</body>
</html>