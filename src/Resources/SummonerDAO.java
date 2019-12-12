package Resources;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class SummonerDAO {

	private Connection dbcon; 
	private ResultSet rs;

	// mysql�� ������ �ִ� �κ�
	public SummonerDAO() { // ������ ����ɶ����� �ڵ����� db������ �̷�� �� �� �ֵ�����
		String DB_URL = "jdbc:mysql://localhost:3306/lol_ledder_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC";
		String DB_USER = "root";
		String DB_PASSWORD = "root";
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			dbcon = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public int insertSummoner(String id,String acountId, String name, int summonerLevel, 
			int profileIconId,String tier,String rank,
			int win, int losses, int leaguePoints, String leagueName,
			int totalGames, int rankPoint) {
		//��ȯ������ ������
		try {
			String sql = "insert into tSummoner(summonerid,accountid, summonername,summonerlevel,profileiconid, Tier, Rank_pos, Wins,Losses,LeaguePoints,LeagueName,totalgames, rankpoint) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, acountId);
			pstmt.setString(3, name); //�̸� �����ֱ�
			pstmt.setInt(4, summonerLevel); //���� �����ֱ�
			pstmt.setInt(5, profileIconId);
			pstmt.setString(6, tier); //Ƽ�����
			pstmt.setString(7, rank);
			pstmt.setInt(8, win);
			pstmt.setInt(9, losses);
			pstmt.setInt(10, leaguePoints);
			pstmt.setString(11, leagueName);
			pstmt.setInt(12, totalGames);
			pstmt.setInt(13, rankPoint);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("��ȯ������ ����");
		}
		return -1;
	}
	
	public boolean foundSummoner(String name) {
		try {
			String sql = "select * from tsummoner where summonername=?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, name);
			rs = pstmt.executeQuery();
			return rs.next();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public String getChampionName(int championId) {
		try {
			String sql = "select CHAMPION_NAME from tChampion_data where CHAMPION_ID =?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setInt(1, championId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				return rs.getString("CHAMPION_NAME");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(championId);
			System.out.println("è�Ǿ��̸� �ҷ����� ����");
		}
		return "e";
	}
	
	public String getChampionImage(int championId) {
		try {
			String sql = "select image from tChampion_data where CHAMPION_ID =?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setInt(1, championId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				return rs.getString("image");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(championId);
			System.out.println("è�Ǿ��̹��� �ҷ����� ����");
		}
		return "e";
	}
	
	public void setSummonerData(String name, SummonerDatas sd) {
		try {
			String sql = "select * from tsummoner where summonername=?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, name);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				sd.setAccountId(rs.getString("accountid")); //�������̵�
				sd.setId(rs.getString("summonerid")); //��ȯ����̵�
				sd.setName(rs.getString("summonername")); //��ȯ���
				sd.setSummonerLevel(rs.getLong("summonerlevel")); //��ȯ�緹��
				sd.setProfileIconId(rs.getInt("profileiconid")); //������
				sd.setRank(rs.getString("rank_pos")); //��ȯ�� ��ũ
				sd.setTier(rs.getString("tier")); //��ȯ�� Ƽ��
				sd.setWin(rs.getInt("wins")); //��ȯ�� �¸�
				sd.setLosses(rs.getInt("losses")); //��ȯ�� �й�
				sd.setLeagueName(rs.getString("leaguename")); //���׸�
				sd.setLeaguePoints(rs.getInt("leaguepoints")); //��������Ʈ
				sd.setTotalGame(rs.getInt("totalgames"));
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("��ȯ�� ���� �ҷ����� ����");
		}
	}
	
	public String getSummonerName(String userId) {
		try {
			String sql = "select userGameID from USER where userID =?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				return rs.getString("userGameID");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(userId);
			System.out.println("���� �г��� �ҷ����� ����");
		}
		return "e";
	}
	
	
}
