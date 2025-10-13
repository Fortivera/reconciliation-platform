import { Routes } from '@angular/router';
import { App } from './app'; // root app stays for '/'
export const routes: Routes = [
    {
        path: '',
        component: App // root page at /
    },
    {
        path: 'login',
        loadComponent: () => import('./pages/login/login').then(m => m.Login)
    }
];
