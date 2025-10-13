import { Routes } from '@angular/router';
export const routes: Routes = [

    {
        path: '',
        loadComponent: () =>
            import('./features/dashboard/pages/dashboard/dashboard').then(m => m.Dashboard),
        children: [
            {
                path: 'dashboard',
                loadComponent: () =>
                    import('./features/dashboard/pages/dashboard/dashboard').then(m => m.Dashboard)
            },
            {
                path: 'upload',
                loadComponent: () =>
                    import('./features/reconciliation/pages/upload/upload').then(m => m.Upload)
            },
            {
                path: 'matching',
                loadComponent: () =>
                    import('./features/reconciliation/pages/matching-workspace/matching-workspace').then(m => m.MatchingWorkspace)
            },
            {
                path: 'exceptions',
                loadComponent: () =>
                    import('./features/reconciliation/pages/exceptions/exceptions').then(m => m.Exceptions)
            },
            {
                path: 'rules',
                loadComponent: () =>
                    import('./features/reconciliation/pages/rules/rules').then(m => m.Rules)            },
            {
                path: 'audit-trail',
                loadComponent: () =>
                    import('./features/reconciliation/pages/audit-trail/audit-trail').then(m => m.AuditTrail)            },
            {
                path: 'reports',
                loadComponent: () =>
                    import('./features/reconciliation/pages/reports/reports').then(m => m.Reports)            },
            {
                
            }
        ]
            }
            
   ,
    {
        path: 'login',
        loadComponent: () =>
            import('./features/auth/pages/login/login').then(m => m.Login)
    }
];