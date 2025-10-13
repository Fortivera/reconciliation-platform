import { Component } from '@angular/core';

@Component({
    selector: 'app-dashboard',
    standalone: true,
    templateUrl: './login.html',
    styleUrl: './login.css'
})
export class Dashboard {
    message = 'This is the login page';
}
