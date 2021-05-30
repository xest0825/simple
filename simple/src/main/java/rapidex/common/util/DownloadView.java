package rapidex.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;

//import rapidex.system.log.ActionLogVO;
//import rapidex.system.log.LogsService;

public class DownloadView extends AbstractView {
	 
//	@Autowired
//	LogsService logsService;
	
    public DownloadView() {
        //setContentType("applicaiton/download;charset=utf-8");
    	//받드시 octet-stream으로 설정해야함
        super.setContentType("application/octet-stream");
    }
 
	@Override
	protected void renderMergedOutputModel(Map<String, Object> model,
		HttpServletRequest request, HttpServletResponse response) throws Exception {
	 	File file = (File) model.get("downloadFile"); // 다운받을 파일의 풀경로
	 	String realFileName = (String) model.get("realFileName"); // realFileName이 다운로드시 파일이름임.
	 	model.put("filePath", file.getAbsolutePath());
	 	response.setContentType(super.getContentType());
        response.setContentLength((int)file.length());

//	 	ActionLogVO alvo = new ActionLogVO();
	 	String actionSeq = (String) model.get("actionSeq");
    	
         
        String fileName = "";
        String userAgent = request.getHeader("User-Agent");
		if (userAgent.indexOf("Trident") > -1 || userAgent.indexOf("MSIE") > -1) {
			fileName = java.net.URLEncoder.encode(realFileName, "UTF-8");
		} else {
			fileName = new String(realFileName.getBytes("UTF-8"), "iso-8859-1");
		}

		response.setHeader("Content-Disposition", "attachment;filename=\""+fileName+"\";");
        response.setHeader("Content-Transfer-Encoding", "binary");
         
        OutputStream out = response.getOutputStream();
        FileInputStream fis = null;
         
        try {
            fis = new FileInputStream(file);

            FileCopyUtils.copy(fis, out);
        } catch (Exception e) {

            e.printStackTrace();
        } finally {
            if (fis != null) { try {out.flush();fis.getFD().sync();fis.close(); } catch (Exception e2) {}}
        }
        
	}
}
