## Challenge #2 – File Storage Flutter Challenge

#### Tasks to complete

Fork [this repository](https://github.com/bepitome/flutter-file-storage-challenge) and create a new branch with prefix of your github username and challenge name. For example if my github account is `mutairibassam` thus my branch should be like `mutairibassam/basic-authentication`.

---

In this challenge you need to develop a portfolio app which shows user profile, user personal image, and user resume. Below are some of the technical requirements which you need to meet.

#### Technical requirements:

-   Application should send device physical id for all requests in headers.
    -   For example: `x-physical-id: 9774d56d682e549c`
-   Application should use multipart to create a new profile. User profile should contain the below data

```yml
{
    "first_name": "Ellerey", # required
    "last_name": "Ellary",
    "national_id": "4114151177", # required
    "email": "ellerey4149@bllerey.io", # required
    "gender": "male", # [male, female, N/A]
    "age": "37",
    "mobile": "0571234567",
    "qualification": "bachelor's degree", # [...qualifications]
    "profile": "http://mypath/611666779607958.jpg", # image network path
    "resume": "http://mypath/385611666779607958.pdf", # file network path
}
```

-   Application should allow users to update only personal details in case they just want to update their personal details.
-   Application should allow users to update only resume in case they just want to update their resume.
-   Application should allow users to update only profile image in case they just want to update their profile image.
-   Application should send files as base64.
-   Application should limit resume to .pdf only.
-   Application should limit profile image to [.png, .jpeg, .jpg] only.

#### Advance Technical requirements (optional):

-   Application should limit uploaded files size up to 250KB for both resume and profile image.

#### Testing:

-   Application should pass all test.

_To download challenge APIs, [click here](https://documenter.getpostman.com/view/20449209/2s8YCYnvWQ)_

<u>Note: We don’t expect something perfect. Just submit what you can do to evaluate your current skills and take you to the next step.</u>

---

#### Project Submission:

For code review - create a pull request and we will do our best to review your code within 72 hours. In case you faced any difficulty with git or github, you are welcome to book a support session [book now](https://calendly.com/mutairibassam).

In case you couldn’t be able to complete the project, don’t give up! We are still here to help you. You can also book a support session with field experts to guide you. For flutter related [Adnan](https://calendly.com/adnsawas), [Majid](https://calendly.com/majidraimi), or [Ayman](https://calendly.com/aymanz-dev) for challenge related [Bassam](https://calendly.com/mutairibassam).

<p style="color:red">Submissions with missing tasks, or buggy apps will be ignored.</p>
