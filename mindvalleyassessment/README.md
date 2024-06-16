Mind Valley Assessment
======================

Overview
--------

This project is an iOS application that uses the VIP architecture (View, Interactor, Presenter) to manage data flow. The app ensures data is loaded from both persistent storage and the network to provide the user with a fast and up-to-date experience. Data is initially retrieved from persistent storage for a quick display, followed by fetching the latest data from the API to update both the storage and the UI.

High-Level Flow
---------------

1.  Initial Load:
    
    *   Retrieve data from persistent storage.
        
    *   Display saved data if available.
        
    *   Fetch the latest data from the API.
        
    *   Update persistent storage and UI with the latest data.
        
2.  Data Flow:
    
    *   View calls the Interactor to fetch data.
        
    *   Interactor requests data from the Worker.
        
    *   Worker retrieves data from the Persistent Service and Network Service.
        
    *   Persistent Service fetches data from Core Data.
        
    *   Data is passed from Worker to Interactor, then to Presenter.
        
    *   Presenter formats the data for the View.
        
    *   View displays the data to the user.
        

Low-Level Flow
--------------

1.  Persistent Data Retrieval:
    
    *   Worker requests data from Persistent Service.
        
    *   Persistent Service retrieves data from Core Data.
        
    *   Data flows back through Worker, Interactor, Presenter to View.
        
2.  Network Data Retrieval:
    
    *   Worker requests data from Network Service.
        
    *   Network Service fetches data via URLSession.
        
    *   Data flows back through Worker, Interactor, Presenter to View.
        

Architecture
------------

The application is built using the VIP architecture:

1.  View:
    
    *   Handles the user interface.
        
    *   Sends user actions to the Interactor.
        
    *   Displays formatted data receives from the Presenter.
        
2.  Interactor:
    
    *   Contains business logic.
        
    *   Processes data requests.
        
    *   Interacts with network or database.
        
    *   Sends raw data responses to the Presenter.
        
3.  Presenter:
    
    *   Receives raw data responses from Interactor.
        
    *   Formats data and send it to the View.
        

Tech Stack
----------

*   Layout:
    
    *   UICollectionView
        
    *   UICollectionViewDiffableDataSource
        
    *   UICollectionViewCompositionalLayout
        
*   Third-Party Libraries:
    
    *   Kingfisher (for image caching)
        
*   Persistent Storage:
    
    *   Core Data
        
*   Unit Testing:
    
    *   XCTest
        
*   Networking:
    
    *   URLSession
        
*   Version Control:
    
    *   Git
        
*   Minimum iOS Version:
    
    *   iOS 13
        

Q&A
---

### What parts of the test did you find challenging and why?

The most challenging part of the test for me was writing unit tests. In my previous company, there wasn't a strong emphasis on unit testing, so I didn't have the opportunity to develop my skills in this area. As a result, I found it particularly difficult to write effective unit tests during the test.

### What feature would you like to add in the future to improve the project?

To enhance the project in the future, I would suggest adding:

*   A dark mode and light mode toggle for improved user experience.
    
*   A pull-to-refresh feature, as it is essential in modern applications.
    
*   A context menu for each UICollectionViewCell, allowing users to share links directly from the cells.
