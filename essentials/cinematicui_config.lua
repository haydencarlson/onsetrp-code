cinematicUIConfig = {
    company = {
        title = "Company Manager",
        message = "Here you can create, join or manage your company. With a company you can upgrade your business to open up yourself and employees to additional revenue streams.",
        actions = {
            {
                text = "Go",
                callback = "ContinueCompanyInteract",
                close_on_click = true
            },
            {
                text = "Cancel",
                close_on_click = true
            }
        }
    },
    jobManager = {
        title = "Job Manager",
        message = "Here you can choose a job or change your current job. After you select your job, instructions will be shown for your job. Look at /help for additional information",
        actions = {
            {
                text = "Go",
                callback = "ContinueJobManagerInteract",
                close_on_click = true
            },
            {
                text = "Cancel",
                close_on_click = true
            }
        }
    }
}