<%@ page import="Resources.SummonerDatas"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<%
	String name = request.getParameter("name");
	Connection dbcon = null;
	//PreparedStatement pstmt = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	SummonerDatas sd = new SummonerDatas();
	double avg = 0;
	String DB_URL = "jdbc:mysql://localhost:3306/lol_ledder_db?serverTimezone=UTC";
	String DB_USER = "root";
	String DB_PASSWORD = "root";
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	}
	//��ȯ������ ���˻�
	try {
		dbcon = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		String sql = "select * from tsummoner where summonername=?";
		pstmt = dbcon.prepareStatement(sql);
		pstmt.setString(1, name);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd.setAccountId(rs.getString("accountid")); //�������̵�
			sd.setId(rs.getString("summonerid")); //��ȯ����̵�
			sd.setName(rs.getString("summonername")); //��ȯ���
			sd.setSummonerLevel(rs.getLong("summonerlevel")); //��ȯ�緹��
			sd.setProfileIconId(rs.getInt("profileiconid")); //������
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	//Ƽ������ ���˻�
	try {
		String sql = "select * from ttierlist where summonerid =?";
		pstmt = dbcon.prepareStatement(sql);
		pstmt.setString(1, sd.getId()); //��ȯ����̵�� �������ޱ�
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd.setRank(rs.getString("rank_pos")); //��ȯ�� ��ũ
			sd.setTier(rs.getString("tier")); //��ȯ�� Ƽ��
			sd.setWin(rs.getInt("wins")); //��ȯ�� �¸�
			sd.setLosses(rs.getInt("losses")); //��ȯ�� �й�
			sd.setLeagueName(rs.getString("leaguename")); //���׸�
			sd.setLeaguePoints(rs.getInt("leaguepoints")); //��������Ʈ
		}
	} catch (Exception e) {
		//e.printStackTrace();
		System.out.println("Ƽ������ �ҷ����� ����");
	}
	//��ġ�������˻�
	try {
		String sql = "select * from tmatchlist where summonerid =?";
		pstmt = dbcon.prepareStatement(sql);
		pstmt.setString(1, sd.getId());
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd.setTotalGame(rs.getInt("totalgames"));
			sd.setParticipateId(rs.getInt("participateid"));
		}
	} catch (Exception e) {
		//e.printStackTrace();
		System.out.println("��Ī���� �ҷ����� ����");
	}
	//è�Ǿ�����
	try {
		String sql = "select * from tChampion_data where CHAMPION_ID =?";
		pstmt = dbcon.prepareStatement(sql);
		pstmt.setInt(1, sd.getChampionId());
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd.setChampionName(rs.getString("CHAMPION_NAME"));
			sd.setImage(rs.getString("image"));
		}
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("è�Ǿ���̵� �ҷ����� ����");
	}
	pstmt.close();
	rs.close();
	dbcon.close();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>���� �˻� ���̺�</title>

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
            <%=sd.getName() %>���� ����</div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                <thead>
                  <tr>
                    <th>��ȯ���</th>
                    <th>����</th>
                    <th>Ƽ��</th>
                    <th>��������Ʈ</th>
                    <th>��ũ ���� �¸�</th>
                    <th>��ũ ���� �й�</th>
                    <th>�÷����� ���� ��</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
					<td><%=sd.getName() %></td>
					<td><%=sd.getSummonerLevel() %></td>
					<td><%=sd.getTier()+" "+sd.getRank() %></td>
					<td><%=sd.getLeaguePoints()+"LP" %></td>
					<td><%=sd.getWin()+"��" %></td>
					<td><%=sd.getLosses()+"��" %></td>
					<td><%="�� "+sd.getTotalGame()+"ȸ" %></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
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