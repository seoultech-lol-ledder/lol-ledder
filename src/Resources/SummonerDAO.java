package Resources;

import Resources.LOLApiKey;
	
import java.sql.*;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import net.rithms.riot.*;
import net.rithms.riot.api.ApiConfig;
import net.rithms.riot.api.RiotApi;
import net.rithms.riot.api.RiotApiException;
import net.rithms.riot.api.endpoints.summoner.dto.Summoner;
import net.rithms.riot.constant.Platform;
import net.rithms.riot.api.endpoints.match.*;
import net.rithms.riot.api.endpoints.match.dto.Match;
import net.rithms.riot.api.endpoints.match.dto.MatchList;
import net.rithms.riot.api.endpoints.match.dto.MatchReference;
import net.rithms.riot.api.endpoints.match.dto.Participant;
import net.rithms.riot.api.endpoints.match.dto.ParticipantStats;
import net.rithms.riot.api.endpoints.league.*;
import net.rithms.riot.api.endpoints.league.methods.*;
import net.rithms.riot.api.endpoints.league.constant.*;
import net.rithms.riot.api.endpoints.league.dto.*;

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

	public int setIsUser(String userGameID) {
		//��ȯ������ ������
		try {
			String sql = "UPDATE TSUMMONER SET IS_USER=TRUE WHERE SUMMONERNAME=?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt.setString(1, userGameID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println(userGameID);
			System.out.println("���� ���� ����");
		}
		return -1;

	}
	
	public void updateSummoner() {
		try {
			String sql = "select summonername from tsummoner";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			rs = pstmt.executeQuery();
		}catch (Exception e) {
			e.printStackTrace();
		}
		//��ȯ������ ������
		try {
			while(rs.next()) {
				LOLApiKey key = new LOLApiKey();
				//api key ����
				ApiConfig cfg = key.getConfig();
				//api�н� ����
				RiotApi api = new RiotApi(cfg);
				Summoner summoner = api.getSummonerByName(Platform.KR, rs.getString("summonername"));
				System.out.println(rs.getString("summonername"));
				//��ȯ�� ����
				String name = summoner.getName(); //��ȯ���̸�
				String id = summoner.getId(); // ��ȯ�� ���̵�
				int summonerLevel = summoner.getSummonerLevel(); //��ȯ�� ����
				//���׿�Ʈ���� ���õ� ����
				Set<LeagueEntry> leagueEntry = api.getLeagueEntriesBySummonerId(Platform.KR, id);
				List<LeagueEntry> tempList = new ArrayList<LeagueEntry>(leagueEntry);
				//��ȯ�� Ƽ������
				String leagueName = tempList.get(0).getLeagueId();//�����̸�
				int leaguePoints = tempList.get(0).getLeaguePoints();//��������Ʈ
				String rank = tempList.get(0).getRank();//���緩ũ
				String tier = tempList.get(0).getTier();//����Ƽ��
				int win = tempList.get(0).getWins();//�¸�Ƚ��
				int losses = tempList.get(0).getLosses();//�й�Ƚ��
				int totalGames = win + losses;//�� �÷��� Ƚ��

				int rankPoint = 0;
				switch(tier) {
				case "CHALLENGER":
					rankPoint += 8000;
					break;
				case "GRANDMASTER":
					rankPoint += 7000;
					break;
				case "MASTER":
					rankPoint += 6000;
					break;
				case "DIAMOND":
					rankPoint += 5000;
					break;
				case "PLATINUM":
					rankPoint += 4000;
					break;
				case "GOLD":
					rankPoint += 3000;
					break;
				case "SILBER":
					rankPoint += 2000;
					break;
				case "BRONZE":
					rankPoint += 1000;
					break;
				case "IRON":
					rankPoint += 0;
					break;
				}
				
				switch(rank) {
				case "I":
					rankPoint += 800;
					break;
				case "II":
					rankPoint += 600;
					break;
				case "III":
					rankPoint += 400;
					break;
				case "IV":
					rankPoint += 200;
					break;
				case "V":
					rankPoint += 0;
					break;
				}
				
				rankPoint += leaguePoints;
				
			String sql = "update tsummoner set summonerLevel=?, tier=?, rank_pos=?, wins=?, losses=?, leaguePoints=?, leagueName=?, totalGames=?, rankPoint=? where summonername=?";
			PreparedStatement pstmt = dbcon.prepareStatement(sql);
			pstmt.setInt(1, summonerLevel);
			pstmt.setString(2, tier); //Ƽ�����
			pstmt.setString(3, rank);
			pstmt.setInt(4, win);
			pstmt.setInt(5, losses);
			pstmt.setInt(6, leaguePoints);
			pstmt.setString(7, leagueName);
			pstmt.setInt(8, totalGames);
			pstmt.setInt(9, rankPoint);
			pstmt.setString(10, name); //�̸� �����ֱ�
			pstmt.executeUpdate();
			}
		} catch (Exception e) {
			//e.printStackTrace();
			System.out.println("��ȯ������ ����");
		}
	}
	
	
}
