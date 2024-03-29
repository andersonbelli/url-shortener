# URL Shortener

Simple app with just one page which consists in a text field
where the URL to be shortened should be inserted and a list with
the latest shortened URLs.

<img width="265" alt="image" src="https://user-images.githubusercontent.com/24509402/152261125-1b4210db-e0cc-414b-846f-fef7dcd7b501.png">


Selecting an item from the list provides options for copying to
clipboard the original or shortened URL:

<img width="240" alt="image" src="https://user-images.githubusercontent.com/24509402/152261154-749c1e83-c170-4b03-88df-a0d1b867633e.png">


If an error occurs or the URL alias is not found, a box message will appear:

<img width="248" alt="image" src="https://user-images.githubusercontent.com/24509402/152261037-d95d472d-e94d-4fd3-ba1c-328a23d84398.png">


## Tests command

The only command that need to be executed is the generator
of mocks files:

 ``` flutter pub run build_runner build --delete-conflicting-outputs ```

And to run the integration tests use the following command:

 ``` flutter test integration_test ```
