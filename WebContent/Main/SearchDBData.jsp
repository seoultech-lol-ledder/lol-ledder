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

	//���������� ���˻�
	try {
		String sql = "select * from tparticipatestat where participateid =?";
		pstmt = dbcon.prepareStatement(sql);
		pstmt.setInt(1, sd.getParticipateId());
		rs = pstmt.executeQuery();
		while (rs.next()) {
			sd.setChampionId(rs.getInt("championid"));
			sd.setKill(rs.getInt("kill_count"));
			sd.setDeath(rs.getInt("death"));
			sd.setAssist(rs.getInt("assist"));
		}
	} catch (Exception e) {
		//e.printStackTrace();
		System.out.println("���������� �ҷ����� ����");
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
<style>
body {
	background-color: #5CD1E5;
	background-image: url(mainimage.jpg)
}

table {
	margin : 350px 0px 0px 380px;
	vertical-align : middle;
	border-collapse: collapse;
	width: 1200px;
}

table, tr, td {
	border: solid 1px #cccccc;
	color : #ffffff;
	font-family : "�������";
}

tr {
	hegiht: 40px;
	text-align: center;
}

#table_title {
	height: 10px;
	background-color: #280848;
}

setcolor{
	color : #ffffff;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	avg = sd.getKill() + sd.getAssist();
	avg = avg / sd.getDeath();
	avg = Double.parseDouble(String.format("%.2f", avg));
%>
	<table>
		<tr id="table_title">
			<td>��ȯ���</td>
			<td>�� ��</td>
			<td>Ƽ��</td>
			<td>���׸�</td>
			<td>��������Ʈ</td>
			<td>��ũ���� �¸�</td>
			<td>��ũ���� �й�</td>
			<td>�� �÷����� ���� ��</td>
			<td>�ֱ� �÷����� è�Ǿ�</td>
			<td>KDA</td>
		</tr>
		<tr>
			<td><%=sd.getName() %></td>
			<td><%=sd.getSummonerLevel() %></td>
			<td><%=sd.getTier()+" "+sd.getRank() %></td>
			<td><%=sd.getLeagueName() %></td>
			<td><%=sd.getLeaguePoints()+"LP" %></td>
			<td><%=sd.getWin()+"��" %></td>
			<td><%=sd.getLosses()+"��" %></td>
			<td><%="�� "+sd.getTotalGame()+"ȸ" %></td>
			<td><img src="Champions/<%=sd.getImage()%>.png"></br><%=sd.getChampionName() %></td>
			<td><%=sd.getKill()+"ų"+sd.getDeath()+"����"+sd.getAssist() +"���"+"</br>���� :"+avg%></td>			
		</tr>
	</table>
<%-- 	<%
		System.out.println(sd.getName());
		System.out.println(sd.getSummonerLevel());
		System.out.println(sd.getTier());
		System.out.println(sd.getRank());
		System.out.println(sd.getLeagueName());
		System.out.println(sd.getLeaguePoints());
		System.out.println(sd.getWin());
		System.out.println(sd.getLosses());
		System.out.println(sd.getTotalGame());
		System.out.println(sd.getKill());
		System.out.println(sd.getDeath());
		System.out.println(sd.getAssist());
		System.out.println(sd.getChampionName());
		System.out.println(sd.getImage());
	%> --%>
</body>
</html>