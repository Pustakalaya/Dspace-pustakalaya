package service;

import java.util.List;

import model.Image;

	
public interface ImageService {
	Image findImageById(Long id);

	List<Image> findAllImage();

	void saveImage(Image image);

	void deleteImageById(Long id);

}
