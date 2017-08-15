package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import model.FileBucket;
import model.Image;
import service.ImageService;
import validator.FileValidator;

public class UploadController {
	     
    @Autowired
    ImageService imageService;
     
    @Autowired
    MessageSource messageSource;
 
    @Autowired
    FileValidator fileValidator;
     
    @InitBinder("fileBucket")
    protected void initBinder(WebDataBinder binder) {
       binder.setValidator(fileValidator);
    }
 
     
    @RequestMapping(value = { "/add-image" }, method = RequestMethod.GET)
    public String addDocuments(@PathVariable Long id, ModelMap model) {
        Image image = imageService.findImageById(id);
        model.addAttribute("image", image);
 
        FileBucket fileModel = new FileBucket();
        model.addAttribute("fileBucket", fileModel);
 
        List<Image> images = (List<Image>) imageService.findImageById(id);
        model.addAttribute("images", images);
         
        return "image uploaded";
    }
     
    @RequestMapping(method = RequestMethod.POST, value = "/image/rest/save")
	public @ResponseBody List<Image> uploadImageBanner(
			@RequestParam("tagline")String tagline,
			@RequestParam("image") MultipartFile file) throws IOException {
		
		List<Image> images=new ArrayList<>();
		Image image=new Image();
		image.setId(new Long("1901"));
		image.setTagline(tagline);
		image.setTitle("This is image uploaded");
		byte[] file1=file.getBytes();
		image.setImage(file1);
		image.setDisplay(false);
	
		imageService.saveImage(image);
		
		
		return  images;
	}
     
	


}
