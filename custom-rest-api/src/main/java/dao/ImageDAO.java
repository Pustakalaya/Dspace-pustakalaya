
package dao;

import java.util.List;

import model.Image;

public interface ImageDAO{

	List<Image> findAllImage();
    
    Image findImageById(Long id);
     
    void save(Image image);
     
     
    void deleteImageById(Long id);
}

