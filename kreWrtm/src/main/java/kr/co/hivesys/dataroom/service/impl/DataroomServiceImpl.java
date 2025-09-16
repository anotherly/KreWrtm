package kr.co.hivesys.dataroom.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.hivesys.comm.file.vo.FileVo;
import kr.co.hivesys.dataroom.mapper.DataroomMapper;
import kr.co.hivesys.dataroom.service.DataroomService;
import kr.co.hivesys.dataroom.vo.DataroomVO;

/**
 * 자료실 서비스 구현 클래스
 * @author 솔루션 디자인팀 최다슬
 * @since 2025.09.05
 * @version 1.0
 * @see
 *
 * << 개정이력(Modification Information) >>
 *
 *   수정일            수정자              수정내용
 *  -------    -------- ---------------------------
 *  2025.09.05  최다슬           최초 생성
 */

@Service("dataroomService")
public class DataroomServiceImpl implements DataroomService{

	@Resource(name="dataroomMapper")
	private DataroomMapper dataroomMapper;
	
	// 자료실 정보 조회
	public List<DataroomVO> selectDataList(DataroomVO dataVO) throws Exception{
		return dataroomMapper.selectDataList(dataVO);
	}
	
	// 자료실 게시판 데이터 조회
	public List<DataroomVO> selectDataBoardList(DataroomVO dataVO) throws Exception {
		return dataroomMapper.selectDataBoardList(dataVO);
	}
	
	// 자료실 상세 정보 조회
	public DataroomVO selectData(DataroomVO dataVO) throws Exception {
		return dataroomMapper.selectData(dataVO);
	}
	
	// 자료실 게시판 상세 정보 조회  
	public DataroomVO selectDataBoard(DataroomVO dataVO) throws Exception {
		return dataroomMapper.selectDataBoard(dataVO);
	}
	
	// 자료실 자료 등록
	public void insertFile(FileVo fileList) throws Exception {
		dataroomMapper.insertFile(fileList);
	}
	
	
	// 자료실 게시판 등록
	public void insertFileBoard(FileVo fileList) throws Exception {
		dataroomMapper.insertFileBoard(fileList);
	}
	
	
	// 자료실 자료 수정
	public void updateFile(FileVo fileList) throws Exception {
		dataroomMapper.updateFile(fileList);
	}
	
	// 게시판 수정
	public void updateFileBoard(FileVo fileList) throws Exception {
		dataroomMapper.updateFileBoard(fileList);
	}
	
	
	// 자료실 자료 삭제
	public void deleteData(List<String> dataArr) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("chkList",dataArr);
		dataroomMapper.deleteData(map);
	}
	
	// 게시판 자료 삭제
	public void deleteDataBaord(List<String> dataArr) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("chkList",dataArr);
		dataroomMapper.deleteDataBaord(map);
	}
	
}
