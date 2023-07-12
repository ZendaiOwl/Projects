/*
 * Functions to fetch data from Docker Engine using Connect client
 */

/* Containers */
pub mod containers_handler {
    // use crate::*;
}

/* Images */
pub mod images_handler {
    use crate::*;
    use crate::connect::Connect;
    #[allow(unused_imports)]
    use crate::models::image_models::ImageList;
    pub async fn list_imgs(c: Connect) -> JSON {
        c.list_images().await
    }
}

/* Networks */
pub mod networks_handler {
    // use crate::*;
}

/* Volumes */
pub mod volumes_handler {
    // use crate::*;
}

/* Exec */
pub mod exec_handler {
    // use crate::*;
}
